# 1. Join all files, matching a given extension ($filter) and path ($srcFolder), into a single file ($outFile).
# 2. Given a table of old and replacement/new strings, update the joined file to reflect that.

$srcFolder = "C:\PowerShell"
$filter = "*.txt"
$outFile = "$srcFolder\joined.file"
# The old values are case-sensitive due to the use of .Net string/Replace below
$oldAndNewStrings = @{
    "and"="whale";
    "to"="terrier";
    "You"="tunnel sous la manche";
}

# No edit below here...
$randomName = Get-Random -Minimum 1 -Maximum 99999
$tempFile =  "$env:TEMP/$randomName.txt"
cd $srcFolder

# Join the files together...
gci -Path $srcFolder -Filter $filter| get-content -Raw | Out-File $tempFile

# Make the replacements...
$oldAndNewStrings.Keys | % {
    $oldValue = $_
    $newValue = $oldAndNewStrings[$oldValue]
    $(Get-Content $tempFile -Raw ).Replace($oldValue, $newValue) | Out-File $tempFile
}

Move-Item -Path $tempFile -Destination $outFile -Force
