﻿<# 
.Synopsis 
    PUBLIC
    Convert an assumed valid string from one datetime format to another date(not time) format.
    If the in-format does not match the expectation, then return the original string.
    This is to support a specific need - it can be become generic in time
.Example 
    convertFrom-yymmddhhmmssFormat "000000000010660228230022" => "28/02/1066"
#>
function convertFrom-yymmddhhmmssFormat ([CmdletBinding()]
    [string] $CandidateDate) {
    $inFormat = "yyyyMMddHHmmss"
    $outFormat = "dd/MM/yyyy"
    $culture = [System.Globalization.CultureInfo]::InvariantCulture
    $noStyle = [System.Globalization.DateTimeStyles]::None

    $candidateDateNoLeadingZeroes = $CandidateDate.TrimStart('0')
    try {
        [datetime]::ParseExact($candidateDateNoLeadingZeroes, $inFormat, $culture).ToString($outFormat)
    } catch {
        $CandidateDate
    }
}

function Convert-DateFieldsInCsvRecord ([string]$RecordToConvert) {
    $convertedRecord = [string]::Empty
    $recordSet = $RecordToConvert -split ","
    $recordSet | % {
        $convertedRecord += "$(convertFrom-yymmddhhmmssFormat $_),"
    }
    # great shortcut to remove last character from a string...
    return $convertedRecord -replace ".$"
}

