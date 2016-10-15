Describe "Date Format Utility" {
    It "converts an incoming date with format [0*]yyyyMMddHHmmss to dd/MM/yyyy" {
        convertFrom-yymmddhhmmssFormat "000000000020120808235959" | should be "08/08/2012"
        convertFrom-yymmddhhmmssFormat "000000000020011231225953" | should be "31/12/2001"
        convertFrom-yymmddhhmmssFormat "000000000010660228230022" | should be "28/02/1066"
        convertFrom-yymmddhhmmssFormat "10660228230022" | should be "28/02/1066"
    }

    It "returns an incoming malformed date without change" {
        convertFrom-yymmddhhmmssFormat "this is nonsense" | should be "this is nonsense"
        convertFrom-yymmddhhmmssFormat "" | should be ""
        convertFrom-yymmddhhmmssFormat "20120404" | should be "20120404"
        convertFrom-yymmddhhmmssFormat "20120432" | should be "20120432"
        convertFrom-yymmddhhmmssFormat "000000000020120899235959" | should be "000000000020120899235959"
    }
}