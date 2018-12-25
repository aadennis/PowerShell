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

$counterMetadataPath = "C:\GitHub\PowerShell\PerformanceCounters\Metadata\PerformanceCountersToRecord.txt"
$sut = "\\" + $env:COMPUTERNAME #'\\desktop-3fe014p'
$sqlInstance = "MSSQL`$SQLEXPRESS"
$maxSamples = 10
$outputFile = "c:\temp\PerfCountersOutput.csv"

cd $env:TEMP
$counters = @()
Get-Content -Path $counterMetadataPath | % {
    $counters += "$sut\" + $ExecutionContext.InvokeCommand.ExpandString($_)
}

"Running Performance counters. Finishes in about [${maxSamples}] seconds"
"Results will be in [$outputFile]"

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

<#
Example content of PerfCountersToRecord.txt:

memory\% committed bytes in use
memory\cache faults/sec
physicaldisk(_total)\% disk time
physicaldisk(_total)\current disk queue length
system\Processor Queue Length
memory\available mbytes
physicaldisk(_total)\avg. disk sec/read
physicaldisk(_total)\avg. disk sec/write
physicaldisk(_total)\disk reads/sec
physicaldisk(_total)\disk writes/sec
processor(_total)\% processor time
${sqlInstance}:General Statistics\User Connections
${sqlInstance}:Memory Manager\Memory Grants Pending
${sqlInstance}:SQL Statistics\Batch Requests/sec
#>
