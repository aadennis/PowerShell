$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\..\.\$sut"

Describe "PerformanceCounters" {
    It "correctly formats the performance counter data" {
        # arrange
        $inputFile = "$here\Assets\TestInputData\PerfCountersOutput.csv" 
        $outputFile = "TestDrive:\FormattedPerfCountersOutput.csv"
        $expectedFile = "$here\Assets\ExpectedResults\ExpectedFormattedPerfCountersOutput.csv"

        # act
        Show-FormattedPerformanceCounters $inputFile $outputFile
        $expectedResultHash = $(Get-FileHash -Path $expectedFile).Hash
        $actualResultHash = $(Get-FileHash -Path $outputFile).Hash

        # assert
        $actualResultHash | Should be $expectedResultHash
    }
}
