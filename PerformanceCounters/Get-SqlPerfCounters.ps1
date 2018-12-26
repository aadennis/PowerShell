<#
Basic performance counter gathering in PowerShell.
The counters to gather are read from $counterMetadataPath. See the example metadata below.

Information on counters with focus on SQL:
https://www.apress.com/gb/book/9781430219026#otherversion=9781430219033
https://mcpmag.com/articles/2018/02/07/performance-counters-in-powershell.aspx
https://www.brentozar.com/archive/2006/12/dba-101-using-perfmon-for-sql-performance-tuning/

Basic cmdlet options for drilling into what is available, as examples:
Get-Counter -ListSet *
Get-Counter -ListSet "MSSQL`$SQLEXPRESS:Memory Manager
Get-Counter -Counter "\\desktop-3fe014p\physicaldisk(_total)\avg. disk writes/sec"

Note that $ in SQL etc must be escaped (e.g. $SQLEXPRESS)
#>
function Show-Error {
    param (
      $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor Red
}

function Show-Status {
    param (
      $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor DarkBlue
}
function Check-CounterExists {
    "Checking that requested counter exist..."
    # $aa = [System.Diagnostics.PerformanceCounterCategory]::GetCategories(();
    # https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.performancecountercategory.counterexists?view=netframework-4.7.2
    # However, seem to need to test for both category and counter, as category can contain nonsense and still return true for
    # for ::Exists($category).
    # ignore until I understand why e.g. _total is not valid
    
    $counters | % {
        $currentCounter = $_
        $a = $currentCounter.ToString().Split("\")
        $category = $a[-2]
        $counter = $a[-1]
        $catExists = [System.Diagnostics.PerformanceCounterCategory]::Exists($category)
        if (!$catExists) {
            Show-Error "Bad category: $currentCounter" 
            break
        }
        $counterExists = [System.Diagnostics.PerformanceCounterCategory]::CounterExists($counter,$category)
        if (!$counterExists) {
            Show-Error "Bad counter: $currentCounter" 
            break
        }
    }
}

# entry point

$counterMetadataPath = "C:\GitHub\PowerShell\PerformanceCounters\Metadata\PerformanceCountersToRecord.txt"
$sut = "\\" + $env:COMPUTERNAME #'\\desktop-3fe014p'
$sqlInstance = "MSSQL`$SQLEXPRESS"
$maxSamples = 5
$outputFile = "c:\temp\PerfCountersOutput.csv"
$commentCharacter = "#"

cd $env:TEMP
$counters = @()
Get-Content -Path $counterMetadataPath | % {
    [string] $unParsed = $_
    if (!$unParsed.StartsWith($commentCharacter)) {
        $counters += "$sut\" + $ExecutionContext.InvokeCommand.ExpandString($unParsed)
    }
}

# ignore - see function comments
# Check-CounterExists

Show-Status "Running Performance counters. Finishes in about [${maxSamples}] seconds"
Show-Status "Results will be in [$outputFile]"

$results = Get-Counter -Counter $counters -MaxSamples $maxSamples | ForEach {
    $_.CounterSamples | ForEach {
        [pscustomobject]@{
            TimeStamp = $_.TimeStamp
            Path = $_.Path
            Value = $_.CookedValue
        }
    }
} 
$results | Out-GridView
$results | Export-Csv -Path $outputFile -NoTypeInformation
