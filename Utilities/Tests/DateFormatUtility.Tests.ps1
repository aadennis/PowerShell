Describe "Date Format Utility" {
    It "converts an incoming date with format [0*]yyyyMMddHHmmss to dd/MM/yyyy" {
    }

    It "returns an incoming malformed date without change" {
    }

    It "does not change a CSV record if there are no dates in the required format" {
        $expectedResult = "the first column,the second field,666555,"
        Convert-DateFieldsInCsvRecord -r $expectedResult | should be $expectedResult
    }

    It "converts any dates in a CSV record to a required format" {
        $csvRecordIn = "the first column,20660228230022,666555,"
        $expectedResult = "the first column,28/02/2066,666555,"
        Convert-DateFieldsInCsvRecord -r $csvRecordIn | should be $expectedResult
    }
}