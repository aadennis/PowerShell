#!/usr/bin/env python3
"""Search .docx files under a folder for a word/phrase, using a persistent cache.

Windows 11, Python 3.8+, standard library only.

Cache: sqlite DB in %LOCALAPPDATA%\\docx_search\\cache.db holding the extracted
(lower-cased) body text of each file. An entry is reused if the file's modified
time and size are unchanged. With --trust-days N, entries cached within the last
N days are reused without even that check (optimistic mode).

Only word/document.xml is searched (not headers, footers, footnotes, comments).
"""

import argparse
import os
import re
import sqlite3
import sys
import time
import zipfile

DEFAULT_FOLDER = r"D:\OneDrive"
DEFAULT_DB = os.path.join(
    os.environ.get("LOCALAPPDATA", os.path.expanduser("~")),
    "docx_search",
    "cache.db",
)

# Colour support: ANSI escapes, only when writing to a terminal and NO_COLOR is not set.
USE_COLOR = sys.stdout.isatty() and "NO_COLOR" not in os.environ
if USE_COLOR and os.name == "nt":
    os.system("")  # side effect: enables ANSI/VT processing in the Windows console


def green(s):
    return f"\033[1;32m{s}\033[0m" if USE_COLOR else s


# <w:t> or <w:t xml:space="preserve">...</w:t>  (does not match <w:tab/> or <w:tbl>)
T_RE = re.compile(r"<w:t(?:\s[^>]*)?>([^<]*)</w:t>")


def extract_text(path):
    """Return lower-cased body text: runs joined within a paragraph, paragraphs split by newline."""
    with zipfile.ZipFile(path) as z:
        xml = z.read("word/document.xml").decode("utf-8", errors="replace")
    paragraphs = ("".join(T_RE.findall(p)) for p in xml.split("</w:p>"))
    return "\n".join(p for p in paragraphs if p).lower()


ATTR_FLAGS = {
    0x1000: "OFFLINE",
    0x400000: "ONLINE_ONLY(recall on data access)",
    0x40000: "ONLINE_ONLY(recall on open)",
    0x400: "REPARSE_POINT",
    0x4000: "ENCRYPTED(EFS)",
    0x1: "READONLY",
}


def describe_failure(path, exc):
    """Short diagnostic: error type, Windows error code, size, and notable file attributes."""
    parts = [type(exc).__name__]
    winerr = getattr(exc, "winerror", None)
    if winerr is not None:
        parts.append(f"winerror={winerr}")  # 5 = access denied, 32 = in use by another process
    try:
        st = os.stat(path)
        parts.append(f"size={st.st_size}")
        attrs = getattr(st, "st_file_attributes", 0)
        flags = [name for bit, name in ATTR_FLAGS.items() if attrs & bit]
        if flags:
            parts.append("attrs=" + "+".join(flags))
    except OSError:
        pass
    return ", ".join(parts)


def find_docx(folder):
    for root, _dirs, files in os.walk(folder):
        for name in files:
            if name.lower().endswith(".docx") and not name.startswith("~$"):
                yield os.path.join(root, name)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("phrase", nargs="?", help="word/phrase to find (prompted if omitted)")
    ap.add_argument("--folder", default=DEFAULT_FOLDER)
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("--trust-days", type=float, default=0,
                    help="reuse cache entries younger than N days without checking the file")
    ap.add_argument("--word", action="store_true", help="whole-word match only")
    ap.add_argument("--rebuild", action="store_true", help="ignore and rebuild the cache")
    args = ap.parse_args()

    prompted = args.phrase is None
    phrase = args.phrase if not prompted else input("Enter the phrase to search for: ")
    phrase = phrase.strip().lower()
    if not phrase:
        sys.exit("No phrase entered.")

    if args.word:
        pattern = re.compile(r"(?<![a-z0-9])" + re.escape(phrase) + r"(?![a-z0-9])")
        matches = lambda text: pattern.search(text) is not None
    else:
        matches = lambda text: phrase in text

    os.makedirs(os.path.dirname(args.db), exist_ok=True)
    db = sqlite3.connect(args.db)
    db.execute(
        "CREATE TABLE IF NOT EXISTS files ("
        "path TEXT PRIMARY KEY, mtime REAL, size INTEGER, cached_at REAL, text TEXT)"
    )
    if args.rebuild:
        db.execute("DELETE FROM files")

    now = time.time()
    trust_secs = args.trust_days * 86400
    seen = set()
    hits, from_cache, read, failed = [], 0, 0, 0

    paths = list(find_docx(args.folder))
    print(f"{len(paths)} .docx files under {args.folder}")

    for path in paths:
        key = os.path.normcase(path)
        seen.add(key)
        try:
            st = os.stat(path)
        except OSError as e:
            print(f"WARN cannot stat {path}: {e}")
            failed += 1
            continue

        row = db.execute(
            "SELECT mtime, size, cached_at, text FROM files WHERE path = ?", (key,)
        ).fetchone()

        text = None
        if row:
            r_mtime, r_size, r_cached, r_text = row
            fresh = trust_secs and (now - r_cached) < trust_secs
            unchanged = r_mtime == st.st_mtime and r_size == st.st_size
            if fresh or unchanged:
                text = r_text
                from_cache += 1

        if text is None:
            try:
                text = extract_text(path)
            except Exception as e:  # bad zip, locked file, online-only and unreachable, etc.
                print(f"WARN cannot read {path}: {describe_failure(path, e)}")
                failed += 1
                continue  # not cached, so it is retried next run
            read += 1
            db.execute(
                "INSERT OR REPLACE INTO files VALUES (?, ?, ?, ?, ?)",
                (key, st.st_mtime, st.st_size, now, text),
            )

        if matches(text):
            print(f"{green('MATCH')}: {path}")
            hits.append(path)

    # Drop cache entries for files that no longer exist under this folder.
    prefix = os.path.normcase(os.path.abspath(args.folder)).rstrip("\\/") + os.sep
    stale = [p for (p,) in db.execute("SELECT path FROM files") if p.startswith(prefix) and p not in seen]
    db.executemany("DELETE FROM files WHERE path = ?", [(p,) for p in stale])
    db.commit()
    db.close()

    print(f"\n{len(hits)} match(es) for '{phrase}'  "
          f"[cache hits: {from_cache}, read: {read}, failed: {failed}, pruned: {len(stale)}]")

    if prompted:  # launched by double-click / prompt: keep the window open
        input("Press Enter to exit")


if __name__ == "__main__":
    main()
    