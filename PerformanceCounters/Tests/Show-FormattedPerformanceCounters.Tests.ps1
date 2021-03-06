$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\..\.\$sut"

Describe "Show-FormattedPerformanceCounters" {
    Context "Correctly formats transposed data" {
        It "when no format parameter is supplied" {
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

        It "when a format parameter is supplied" {
            # arrange
            $inputFile = "$here\Assets\TestInputData\PerfCountersOutput.csv" 
            $outputFile = "TestDrive:\FormattedPerfCountersOutput.csv"
            $formatMask = "0.#####"
            $expectedFile = "$here\Assets\ExpectedResults\ExpectedFormattedPerfCountersOutput.csv"

            # act
            Show-FormattedPerformanceCounters $inputFile $outputFile $formatMask
            $expectedResultHash = $(Get-FileHash -Path $expectedFile).Hash
            $actualResultHash = $(Get-FileHash -Path $outputFile).Hash

            # assert
            $actualResultHash | Should be $expectedResultHash
        }
    }
}
