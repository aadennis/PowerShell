<#
All credit for the pivot principle here:
https://gallery.technet.microsoft.com/scriptcenter/Powershell-Script-to-7c8368be (Sam Boutros)

Beyond that principle, this script takes the output from my performance counter PowerShell script
and groups by performance counter type, separated by each second in the sample.
I don't know how this behaves at high-volume yet, and indeed it needs to be re-transposed to
make the rows the columns and the columns the rows (because it is natural for this to have
the counter types along the top, and the intervals on the y axis)
#>


function Show-FormattedPerformanceCounters() {
    Set-StrictMode -Version Latest

    $inputFile = "C:\GitHub\PowerShell\PerformanceCounters\PerfCountersOutput.csv" # for testing, populate this with the example below
    $outputFile = "c:\temp\FormattedPerfCountersOutput.csv"
    $formatMask = "0.####"

    $inputArray = import-csv $inputFile
    $outputArray = @()
    foreach ($path in $inputArray.Path | Select-Object -Unique) {
        $paths = [ordered]@{ Path = $path }
        foreach ($timeStamp in $inputArray.TimeStamp | Select-Object -Unique){ 
            $value = ($inputArray.where({ $_.TimeStamp -eq $timeStamp -and $_.Path -eq $path })).Value
            $formattedValue = ([decimal] $value).ToString($formatMask)
            $paths += @{ $timeStamp = $formattedValue }
        }
        $outputArray += New-Object -TypeName PSObject -Property $paths
    }

    $outputArray | Format-Table -AutoSize
    $outputArray | Export-Csv $outputFile -NoTypeInformation 
}

Show-FormattedPerformanceCounters

<#
Test input file example:
"TimeStamp","Path","Value"
"20/12/2018 22:16:22","\\denpc\memory\% committed bytes in use","70.2999309334671"
"20/12/2018 22:16:22","\\denpc\memory\cache faults/sec","52.8245748693165"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\% disk time","0.157942836149275"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:22","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:22","\\denpc\memory\available mbytes","5748"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\avg. disk sec/write","9.32647058823529E-05"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:22","\\denpc\physicaldisk(_total)\disk writes/sec","33.8874631237125"
"20/12/2018 22:16:22","\\denpc\processor(_total)\% processor time","10.5003047285625"
"20/12/2018 22:16:22","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:22","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:22","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:23","\\denpc\memory\% committed bytes in use","70.305122032367"
"20/12/2018 22:16:23","\\denpc\memory\cache faults/sec","0.960747230766201"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\% disk time","0.0908245580612848"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:23","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:23","\\denpc\memory\available mbytes","5748"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\avg. disk sec/read","0.0006303"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\avg. disk sec/write","0"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\disk reads/sec","2.8822416922986"
"20/12/2018 22:16:23","\\denpc\physicaldisk(_total)\disk writes/sec","0"
"20/12/2018 22:16:23","\\denpc\processor(_total)\% processor time","15.9387684539622"
"20/12/2018 22:16:23","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:23","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:23","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:24","\\denpc\memory\% committed bytes in use","70.307847850562"
"20/12/2018 22:16:24","\\denpc\memory\cache faults/sec","64.317323069476"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\% disk time","0.0319911782322247"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:24","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:24","\\denpc\memory\available mbytes","5748"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\avg. disk sec/write","0.000215533333333333"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:24","\\denpc\physicaldisk(_total)\disk writes/sec","2.96849183397581"
"20/12/2018 22:16:24","\\denpc\processor(_total)\% processor time","17.2823212078555"
"20/12/2018 22:16:24","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:24","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:24","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:25","\\denpc\memory\% committed bytes in use","70.3081685514907"
"20/12/2018 22:16:25","\\denpc\memory\cache faults/sec","0"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\% disk time","0"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:25","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:25","\\denpc\memory\available mbytes","5748"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\avg. disk sec/write","0"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:25","\\denpc\physicaldisk(_total)\disk writes/sec","0"
"20/12/2018 22:16:25","\\denpc\processor(_total)\% processor time","14.5834814396948"
"20/12/2018 22:16:25","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:25","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:25","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:26","\\denpc\memory\% committed bytes in use","70.3049015650304"
"20/12/2018 22:16:26","\\denpc\memory\cache faults/sec","0"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\% disk time","0"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:26","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:26","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\avg. disk sec/write","0"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:26","\\denpc\physicaldisk(_total)\disk writes/sec","0"
"20/12/2018 22:16:26","\\denpc\processor(_total)\% processor time","13.02677359215"
"20/12/2018 22:16:26","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:26","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:26","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:27","\\denpc\memory\% committed bytes in use","70.3055830137584"
"20/12/2018 22:16:27","\\denpc\memory\cache faults/sec","91.0237790718325"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\% disk time","0.0449176740164118"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:27","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:27","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\avg. disk sec/write","0.000151333333333333"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:27","\\denpc\physicaldisk(_total)\disk writes/sec","5.93633341772821"
"20/12/2018 22:16:27","\\denpc\processor(_total)\% processor time","23.8644139232917"
"20/12/2018 22:16:27","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:27","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:27","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:28","\\denpc\memory\% committed bytes in use","70.3035987844466"
"20/12/2018 22:16:28","\\denpc\memory\cache faults/sec","0"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\% disk time","0"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:28","\\denpc\system\processor queue length","1"
"20/12/2018 22:16:28","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\avg. disk sec/write","0"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:28","\\denpc\physicaldisk(_total)\disk writes/sec","0"
"20/12/2018 22:16:28","\\denpc\processor(_total)\% processor time","13.8316316663872"
"20/12/2018 22:16:28","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:28","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:28","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:29","\\denpc\memory\% committed bytes in use","70.3029774525908"
"20/12/2018 22:16:29","\\denpc\memory\cache faults/sec","0"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\% disk time","0.0182402808051577"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:29","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:29","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\avg. disk sec/write","0.000368"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:29","\\denpc\physicaldisk(_total)\disk writes/sec","0.991254066248086"
"20/12/2018 22:16:29","\\denpc\processor(_total)\% processor time","13.2595342146033"
"20/12/2018 22:16:29","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:29","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:29","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:30","\\denpc\memory\% committed bytes in use","70.3008929896869"
"20/12/2018 22:16:30","\\denpc\memory\cache faults/sec","0.989854094516614"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\% disk time","0"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:30","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:30","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\avg. disk sec/write","0"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:30","\\denpc\physicaldisk(_total)\disk writes/sec","0"
"20/12/2018 22:16:30","\\denpc\processor(_total)\% processor time","18.0218652575947"
"20/12/2018 22:16:30","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:30","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:30","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"
"20/12/2018 22:16:31","\\denpc\memory\% committed bytes in use","70.3079480841542"
"20/12/2018 22:16:31","\\denpc\memory\cache faults/sec","3.95861623006923"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\% disk time","0.0462207213104242"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\current disk queue length","0"
"20/12/2018 22:16:31","\\denpc\system\processor queue length","0"
"20/12/2018 22:16:31","\\denpc\memory\available mbytes","5747"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\avg. disk sec/read","0"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\avg. disk sec/write","0.0001167625"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\disk reads/sec","0"
"20/12/2018 22:16:31","\\denpc\physicaldisk(_total)\disk writes/sec","7.91723246013847"
"20/12/2018 22:16:31","\\denpc\processor(_total)\% processor time","14.5761413406107"
"20/12/2018 22:16:31","\\denpc\mssql$sqlexpress:general statistics\user connections","2"
"20/12/2018 22:16:31","\\denpc\mssql$sqlexpress:memory manager\memory grants pending","0"
"20/12/2018 22:16:31","\\denpc\mssql$sqlexpress:sql statistics\batch requests/sec","0"

#>