$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

Describe "ObjectUtility" {
    Context "ConvertFrom-CsvRecordToObject" {
        It "converts from a delimited record to an object - default delimiter" {
            $csvRecord = "Apple^99^Orange-peel"
            $csvHeader = "field1^Field2^fielD3"
            $result = ConvertFrom-CsvRecordToObject -csvRecord $csvRecord -header $csvHeader
            $result.field1 | Should -Be "Apple"
            $result.field2 | Should -Be "99"
            $result.field3 | Should -Be "Orange-Peel"
        }
        It "converts from a delimited record to an object - non-default delimiter" {
            $csvRecord = "Apple!99!Orange-peel"
            $csvHeader = "field1!Field2!fielD3"
            $result = ConvertFrom-CsvRecordToObject -csvRecord $csvRecord -header $csvHeader -delimiter "!"
            $result.field1 | Should -Be "Apple"
            $result.field2 | Should -Be "99"
            $result.field3 | Should -Be "Orange-Peel"
        }
    }
}
