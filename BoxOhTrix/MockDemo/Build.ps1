function Build ($version) {
	Write-Host "a build was run for version: $version"
}

function BuildIfChanged {
	$thisVersion = Get-Version
	$nextVersion = Get-NextVersion
	if ($thisVersion -ne $nextVersion) { 
		Build $nextVersion 
	}
	return $nextVersion
}

