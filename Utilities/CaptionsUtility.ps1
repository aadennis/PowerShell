<#
.SYNOPSIS
    convert VTT (captions) format to plain text
.DESCRIPTION
    Strip out duplicates and timestamps
.EXAMPLE
  Convert-fromVttToText.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

function Convert-fromVttToText($VttFile) {
    $captionContent = Get-Content $VttFile
    $captionContent[0]
}