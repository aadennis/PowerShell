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

    Context "ConvertFrom-CsvObjectToPsObject" {
        It "converts from a delimited record to an object - default delimiter" {
            $csvObject = @()
            $csvObject += 'field1^Field2^fielD3'
            $csvObject += 'Apple^99^Orange-peel'

            $result = ConvertFrom-CsvObjectToPsObject -csvObject $csvObject

            write-host($result)
            
            $result[0].field1  | should be "Apple"
            $result[0].field2  | should be 99
            $result[0].field3  | should be "Orange-peel"
        }

        It "converts from a delimited record set to an object - non-default delimiter" {
            $csvObject = @()
            $csvObject += 'field1``Field2``fielD3'
            $csvObject += 'Apple``99``Orange-peel'
            $csvObject += 'Marmite``2001``VeggieMite'

            $result = ConvertFrom-CsvObjectToPsObject -csvObject $csvObject -Delimiter "``"
            
            $result[1].field1  | should be "Marmite"
            $result[1].field2  | should be 2001
            $result[1].field3  | should be "VeggieMite"
        }
    }    
}
