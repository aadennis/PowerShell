Set-StrictMode -Version latest
function ConvertFrom-CsvRecordToObject($csvRecord, $header, $delimiter = "^") {
    $objectMetadata = $header.Split($delimiter)
    $objectData = $csvRecord.Split($delimiter)
    $fieldCount = ($objectMetadata.count) - 1
    
    $dynamicObject = New-Object -TypeName PSObject

    0..$fieldCount | ForEach-Object {
        $currCount = $_
        $dynamicObject | Add-Member -MemberType NoteProperty -Name $objectMetadata[$currCount] -Value $objectData[$currCount]
    }
    $dynamicObject
}
