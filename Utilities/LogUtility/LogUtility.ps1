#https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx

<# 
.Synopsis 
    PRIVATE
    Create a new Windows Log for logging messages from PowerShell.
    It seems to be necessary to seed the new log with an entry to get it to materialize,
    hence the apparently redundant Write-EventLog entry.
    Naive.
.Example 
    New-PsLog -LogName "YoutubeDemo"
#>
function New-PsLog ([string]$LogName) {
    New-EventLog -LogName $LogName -Source $LogName
    Write-EventLog -LogName $LogName -Source $LogName -Message "initial entry: discard" -EventId 1
}

<# 
.Synopsis 
    PUBLIC
    Write a message to an existing Windows Event Log.
    Assumption: the logname and the source have the same name.
.Example 
    Add-PsLogMessage -LogName "YoutubeDemo" -Message "anything"
#>
function Add-PsLogMessage(
    [string]$LogName,
    [string]$Message) {
    Write-EventLog -LogName $LogName -Source $LogName -Message $Message -EventId 1
}