# Usage: Run this script to ensure all .docx files are not pinned to cloud-only, allowing them to be fully downloaded.

Get-ChildItem -Path "D:\OneDrive" -Recurse -Filter *.docx -File |
    ForEach-Object {
        attrib.exe -P $_.FullName  # Clear "pinned to cloud-only" attribute
    }
