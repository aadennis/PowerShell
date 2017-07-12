# Runs all test suites, passes the output to the NUnit format, renders it, displays in a browser
# see my article here for installing nuget via Choco: 
# https://dennisaa.wordpress.com/2017/04/26/powershell-updating-jpg-metadata/
# https://www.nuget.org/packages/ReportUnit/
nuget.exe install ReportUnit
#Then, for example...
# Execute all the tests
$outputName = Get-Random
$outputFile = "$PSScriptRoot/$outputName.xml"
$htmlFile = "$PSScriptRoot/$outputName.html"
Invoke-Pester -PassThru -Strict -OutputFile $outputFile -OutputFormat NUnitXml
.\ReportUnit.1.2.1\tools\ReportUnit.exe $outputFile
Start-Process chrome $htmlFile
