<#
.SYNOPSIS
    convert VTT (captions) format to plain text
.DESCRIPTION
    Strip out duplicates and timestamps. Naively...
    Skip the first 9 records to get the first text line.
    Unique text lines are then every 8th line after that.
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
    $captionContent = Get-Content $VttFile | Select-Object -Skip 9
    #$VttLength = ($captionContent).count
    #$VttLength
    $count = 0
    $captionAsText = @()
    $captionContent | ForEach-Object {
        if (($count % 8 ) -eq 0) {
            $captionAsText = $captionAsText + $_
        }
        $count++
    }
    $captionAsText
}