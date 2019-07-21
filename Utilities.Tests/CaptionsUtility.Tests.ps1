# Captions (VTT) utility tests in PowerShell 

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

Describe "CaptionsUtility" {

    # todo - store a test pdf in the test artifacts folder, and use that.
    Context "Convert-fromVttToText" {
        It "Returns text when passed a Vtt file" {
            $file = "$here/Data/captions.vtt"
            $textConvertedFromVtt = Convert-fromVttToText $file
            $textConvertedFromVtt | Should Be "WEBVTT"
        }
    }
}