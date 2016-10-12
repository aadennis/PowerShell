Describe "Date Format Utility" {
    It "converts an incoming date with format [0*]yyyyMMddHHmmss to dd/MM/yyyy" {
        convertFrom-yymmddhhmmssFormat "000000000020120808235959" | should be "08/08/2012"
        convertFrom-yymmddhhmmssFormat "000000000020011231225953" | should be "31/12/2001"
        convertFrom-yymmddhhmmssFormat "000000000010660228230022" | should be "28/02/1066"
    }

    It "converts an incoming malformed date to 00/00/0000" {
        convertFrom-yymmddhhmmssFormat "this is nonsense" | should be "00/00/0000"
        convertFrom-yymmddhhmmssFormat "" | should be "00/00/0000"
        convertFrom-yymmddhhmmssFormat "20120404" | should be "00/00/0000"
        convertFrom-yymmddhhmmssFormat "20120432" | should be "00/00/0000"
        convertFrom-yymmddhhmmssFormat "000000000020120899235959" | should be "00/00/0000"
    }
}