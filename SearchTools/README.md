# Search-Docx

Search-Docx is a small Windows-focused Python utility for scanning a folder tree of `.docx` files and reporting which documents contain a target word or phrase.

It is designed for the common case where a folder contains many Word documents and you need a quick, low-overhead way to find relevant files without opening each document manually.

This script is intentionally simple and dependency-free: it uses only the Python standard library and works by reading the text stored inside each `.docx` package.

## Why this script exists

`.docx` files are zip archives containing XML documents. The text you see in Word is stored in files like `word/document.xml`, but it is not a plain-text file you can search with a normal text grep tool.

A naïve search of the raw `.docx` archive would usually fail or be noisy because the file is compressed and contains metadata, formatting, and XML structure. This script solves that by:

- walking a target directory recursively,
- opening each `.docx` file as a zip archive,
- extracting only the main document body text,
- normalizing it to lowercase,
- comparing it against the user-supplied search term,
- caching the extracted text so repeated searches are fast.

This makes it especially useful when:

- you have a large document library,
- you want to find a phrase across many Word files,
- you need to run repeated searches without re-reading every file every time,
- you want a lightweight, portable search tool without installing Office or third-party libraries.

## What the script does

The script accepts a phrase and a folder to search:

- it recursively finds all `*.docx` files under the target folder,
- it ignores temporary lock files such as `~$...docx`,
- it reads the document text from the Word XML payload,
- it matches the phrase either as a plain substring or as a whole-word match,
- it prints each matching file path,
- it stores extracted text in a SQLite cache so future scans can reuse it.

It is not a full document search engine. It does not parse comments, headers, footers, footnotes, or revision metadata. It intentionally focuses on the document body text in `word/document.xml`.

## How it works

### 1) File discovery

The script uses `os.walk()` to traverse the chosen folder recursively.

For each file it finds:

- it checks the extension `.docx`,
- it lowercases the filename,
- it rejects files starting with `~$` because those are temporary lock files created by Word while a document is open.

This produces the candidate list of documents to inspect.

### 2) Cache lookup

The script maintains a SQLite database at:

- `%LOCALAPPDATA%\docx_search\cache.db`
- or a custom path supplied with `--db`

The database table is named `files` and stores:

- `path` (normalized file path)
- `mtime` (modified time)
- `size`
- `cached_at` (when the text was cached)
- `text` (lowercased extracted document body text)

On each run, it checks whether the file is already in the cache and whether the file has changed. A cached item is reused when one of these is true:

- the file's size and last modified time are unchanged, or
- `--trust-days` is set and the cached entry is newer than the chosen trust window.

This is an optimization for repeated searches over stable document collections.

### 3) Reading the document body

A `.docx` file is a zip archive. The script opens it with Python's `zipfile` module and reads:

- `word/document.xml`

That XML file contains the main body content of the document, including paragraph text and runs of text formatting. The script extracts only text nodes that use the Word XML element:

- `<w:t>...</w:t>`

The regular expression is designed to match text runs in normal paragraphs, while ignoring structure such as tabs and table elements.

The logic effectively does this:

- split the XML by paragraph boundaries,
- collect each text run within a paragraph,
- join the runs into one string,
- split paragraphs using newline characters,
- lowercase the final result.

This gives a plain-text representation of the document body that can be searched quickly.

### 4) Matching logic

The script normalizes the user phrase to lowercase before comparing it against the extracted document text.

Matching modes:

- default: substring search (`phrase in text`)
- `--word`: whole-word match using a regex boundary check

A whole-word match is useful when searching for terms that should not match inside larger words. For example:

- searching for `cat` will match `cat`, but not `concatenate`
- with whole-word mode, a match requires non-word boundaries around the phrase

### 5) Result reporting and stale cleanup

After each document is checked, the script prints matches like:

- `MATCH: C:\path\to\document.docx`

At the end, it prints summary statistics such as:

- number of matched files,
- number of cache hits,
- number of files read from disk,
- number of read failures,
- number of stale cache entries pruned.

It also cleans up stale entries for files that no longer exist under the target folder, so the cache does not accumulate obsolete paths.

## Why it uses a cache

The expensive part of the operation is de-compressing Word XML and scanning all document text. If you search the same folder repeatedly, reading every document from disk each time wastes time.

The cache stores the extracted body text and associated file metadata, then reuses it if the file is unchanged. This makes repeated searches much quicker, especially for a large folder tree.

The script also supports a more optimistic mode:

- `--trust-days N`

This reuses text from a cache entry if it is younger than N days, even if the file's metadata is not checked. This is useful when you trust the collection to be stable and want faster repeated scans.

## Command-line usage

Run from a terminal:

```bash
python Search-Docx.py "invoice"
```

This searches the default folder, which is set to:

```text
D:\OneDrive
```

You can point it at a different folder:

```bash
python Search-Docx.py "contract" --folder "D:\Documents\Legal"
```

Search for a whole word only:

```bash
python Search-Docx.py "report" --word
```

Force a cache rebuild:

```bash
python Search-Docx.py "policy" --rebuild
```

Use a more aggressive cache trust policy:

```bash
python Search-Docx.py "quarterly" --trust-days 7
```

Change the cache database location:

```bash
python Search-Docx.py "audit" --db "C:\Temp\my-docx-cache.db"
```

### Interactive usage

If you omit the phrase on the command line, the script prompts:

```bash
Enter the phrase to search for:
```

This mode is useful when launched manually or by double-clicking the script in Windows Explorer.

## Arguments

The script uses `argparse` with the following options:

- `phrase` - optional search text; prompted if omitted
- `--folder` - root folder to search recursively (default `D:\OneDrive`)
- `--db` - SQLite cache database path (default `%LOCALAPPDATA%\docx_search\cache.db`)
- `--trust-days N` - reuse newer cached entries without re-checking file metadata
- `--word` - require whole-word matches
- `--rebuild` - clear the existing cache before searching

## Output example

Example output:

```text
123 .docx files under D:older
MATCH: D:olderile1.docx
MATCH: D:olderolder2inal.docx

2 match(es) for 'invoice'  [cache hits: 118, read: 5, failed: 0, pruned: 1]
```

The summary tells you:

- how many documents were checked,
- how many matches were found,
- how many cached entries were reused,
- how many files had to be re-read,
- how many failed to be processed,
- how many stale cache rows were removed.

## Error handling and resilience

The script is intentionally robust when files cannot be read:

- unreadable `.docx` files are skipped,
- the script prints a warning with a short diagnostic,
- the error includes details such as:
  - exception type,
  - Windows error code,
  - file size,
  - file attribute flags if available.

Typical reasons include:

- file is locked by Microsoft Word,
- file is in use by another process,
- file is partially downloaded,
- file is corrupt,
- network-only or cloud-synced content is temporarily unavailable.

The script does not cache failed reads, so those files may be retried on the next run.

## Limitations

This script focuses on a practical subset of document search behavior and intentionally does not attempt to be a complete Word parser.

Current limitations include:

- it searches only the main document body (`word/document.xml`),
- it ignores headers, footers, comments, tracked changes, notes, and other document parts,
- it matches plain visible text, not formatting or object metadata,
- it is optimized for Windows and `.docx` files created by Word,
- whole-word matching is based on ASCII/alphanumeric boundaries and is not a full language-aware tokenizer.

This is a tradeoff that keeps the script lightweight, fast, and easy to trust.

## Why the script is relatively fast

The script is efficient because it avoids parsing the entire Office file format in a complex way. Instead it:

- reads one XML file from the archive,
- extracts only text nodes,
- normalizes the text,
- compares against the phrase.

This is usually much faster than opening every document in Word itself, especially when the folder contains many files.

## Typical use cases

This utility is useful for:

- searching a document archive for a legal clause or policy term,
- locating contract references across many Word files,
- finding project reports by customer, client, or product name,
- identifying incident notes or operational documents containing particular phrases,
- hunting for a phrase across many generated `.docx` outputs.

## Implementation notes

The script is deliberately compact and readable. Key implementation details:

- standard library only (`argparse`, `os`, `re`, `sqlite3`, `zipfile`)
- color output supported for terminals when available
- SQLite used as the persistent cache backend
- no external dependencies or packaging required

The code is designed to be easy to understand and modify if you need to expand its behavior.

## Summary

In one sentence: the script is a lightweight, cached `.docx` search tool that reads the text stored in Word's XML document body, searches it for a phrase, and reuses prior results to speed up repeated scans.

It solves the practical problem of locating a word or phrase across dozens or hundreds of Word files without requiring Office automation or a heavy document indexer.
