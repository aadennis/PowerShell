Describe "Logging Utility" {
    $logName = "LogForTesting"
    
    It "creates a new Windows Event Log [$logName]" {
        # Arrange
        Remove-EventLog -LogName $logName -ErrorAction SilentlyContinue

        # Act
        New-PSLog $logName

        # Assert
        Get-EventLog -LogName $LogName -Source $LogName | Should be $true
    }

    It "writes an entry to an event log" {
        $uniqueMsg = [system.guid]::NewGuid()
        Add-PsLogMessage -LogName $logName -Message "This is a unique message: $uniqueMsg"
    }
}