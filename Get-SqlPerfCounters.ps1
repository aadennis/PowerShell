#https://www.apress.com/gb/book/9781430219026#otherversion=9781430219033
#https://mcpmag.com/articles/2018/02/07/performance-counters-in-powershell.aspx
#https://www.brentozar.com/archive/2006/12/dba-101-using-perfmon-for-sql-performance-tuning/
#Get-Counter -ListSet *
#Get-Counter -ListSet "MSSQL`$SQLEXPRESS:Memory Manager
#Note that $ in SQL etc must be escaped
$sut = '\\desktop-3fe014p'
$sqlInstance = "MSSQL`$SQLEXPRESS"

$CountersNoSut = @(
   "memory\% committed bytes in use",
   "memory\cache faults/sec",
   "physicaldisk(_total)\% disk time",
   "physicaldisk(_total)\current disk queue length",
   "system\Processor Queue Length",
   "memory\available mbytes",
   "physicaldisk(_total)\avg. disk sec/read",
   "physicaldisk(_total)\avg. disk sec/write",
   "physicaldisk(_total)\disk reads/sec",
   "physicaldisk(_total)\disk writes/sec",
   "processor(_total)\% processor time",
   "${sqlInstance}:General Statistics\User Connections",
   "${sqlInstance}:Memory Manager\Memory Grants Pending",
   "${sqlInstance}:SQL Statistics\Batch Requests/sec"
   #"${sqlInstance}:SQL Statistics\reCompilations/sec",
)

$Counters = $CountersNoSut | % {
    "$sut\$_"
}
"Counters monitored:"
$Counters

Get-Counter -Counter $Counters -MaxSamples 5 | ForEach {
    $_.CounterSamples | ForEach {
        [pscustomobject]@{
            TimeStamp = $_.TimeStamp
            Path = $_.Path
            Value = $_.CookedValue
        }
    }
} #| Export-Csv -Path PerfMonCounters.csv -NoTypeInformation

#Get-Counter -ListSet *
#Get-Counter -ListSet "MSSQL`$SQLEXPRESS:Memory Manager"
#Get-Counter -Counter "\\desktop-3fe014p\physicaldisk(_total)\avg. disk writes/sec"



