$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

# The functions to be mocked must exist...
Remove-Item -Path Function:\Get-Version
Remove-Item -Path Function:\Get-NextVersion
function Get-Version {}
function Get-NextVersion {}

Describe "BuildIfChanged" {
	Context "When there are Changes" {
		Mock Get-Version {return 1.1}
		Mock Get-NextVersion {return 1.2}
		Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2}

		$result = BuildIfChanged

		It "Builds the next version" {
			Assert-VerifiableMocks
			Assert-MockCalled Build -Times 1 -ParameterFilter {$version -eq 1.2}
		}
		It "returns the next version number" {
			$result | Should Be 1.2
		}
	}
	Context "When there are no Changes" {
		Mock Get-Version { return 1.1 }
		Mock Get-NextVersion { return 1.1 }
		Mock Build {}

		BuildIfChanged

		It "Should not build the next version" {
			Assert-MockCalled Build -Times 0 -ParameterFilter {$version -eq 1.1}
		}
	}
}