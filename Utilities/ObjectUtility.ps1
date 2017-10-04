Set-StrictMode -Version latest
function ConvertFrom-CsvRecordToObject($csvRecord, $header, $delimiter = "^") {
    $objectMetadata = $header.Split($delimiter)
    $objectData = $csvRecord.Split($delimiter)
    $fieldCount = ($objectMetadata.count) - 1
    $dynamicObject = New-Object -TypeName PSObject

    0..$fieldCount | ForEach-Object {
        $currCount = $_
        #https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-member?view=powershell-5.1
        #$dynamicObject | Add-Member @{$objectMetadata[$currCount]=$objectData[$currCount]} -PassThru
        $dynamicObject | Add-Member -MemberType NoteProperty -Name $objectMetadata[$currCount] -Value $objectData[$currCount]
    }
    $dynamicObject
}

function ConvertFrom-CsvObjectToPsObject($csvObject, $delimiter) {
    $csvObject | ConvertFrom-Csv -Delimiter $delimiter
}
