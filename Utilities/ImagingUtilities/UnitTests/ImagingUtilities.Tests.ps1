﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# todo - store a test pdf in the test artifacts folder, and use that.

. "$here\..\$sut"

Describe "ConvertTo-PngFromPdf" {

    It "Converts from a PDF to a PNG file" {
        $folder = "c:/temp/x"
        ConvertTo-PngSetFromPdf -PdfPngFolder $folder
        $true | Should Be $false
    }
}


