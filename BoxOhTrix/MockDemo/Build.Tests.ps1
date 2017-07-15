﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "BuildIfChanged" {
    Context "When there are Changes" {
    	Mock Get-Version {return 1.1}
    	Mock Get-NextVersion {return 1.2}
    	Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2}

    	$result = BuildIfChanged

	    It "Builds the next version" {
	        Assert-VerifiableMocks
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