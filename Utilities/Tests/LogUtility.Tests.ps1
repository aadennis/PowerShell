Describe "Logging Utility" {
    $logName = "LogForTesting"
    
    It "creates a new Windows Event Log [$logName]" {
        # Arrange
        Remove-EventLog -LogName $logName
        # Act
        New-PSLog $logName
        # Assert
        Get-EventLog -LogName $LogName -Source $LogName | Should be $true
    }

    It "writes an entry to an event log" {
        # Arrange
        $uniqueMsg = [system.guid]::NewGuid()
        # Act
        Add-PsLogMessage -LogName $logName -Message "This is a unique message: $uniqueMsg"
        # Assert
        (Get-WinEvent -LogName "LogForTesting" | 
            where -Property Message -like "*$uniqueMsg").count | 
            should be 1
    }
}