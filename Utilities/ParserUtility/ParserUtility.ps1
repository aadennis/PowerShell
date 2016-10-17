

$p=[System.Management.Automation.Language.Parser]::ParseFile('C:\tempo\PowerShell\Utilities\LogUtility\LogUtility.ps1',[ref]$tokens,[ref]$parseerrors)
# now review parsedResults, tokens and parseerrors
$p.Extent
# list the tokens
#$tokens|ft -auto

$parseerrors.Count

