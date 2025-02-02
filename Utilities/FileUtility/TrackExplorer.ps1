# Track folders visited by File Explorer
# Pausing for n seconds before comparing old and current locations.
# Do not log a path if it has already been recorded in this session.
#
# Todo - add support for the Files app

# Base path for log file
$baseLogFile = "D:\sandbox\ExplorerHistory_Simplified.txt"
$SLEEP_SECONDS = 5
$SHOW_TIME = $false  # Show timestamp and "New path detected:" if true

# Ensure unique log file by appending a timestamp if the base file exists
if (Test-Path $baseLogFile) {
    $timestampSuffix = (Get-Date -Format "yyyyMMdd_HHmmss")
    $logFile = $baseLogFile -replace '\.txt$', "_$timestampSuffix.txt"
} else {
    $logFile = $baseLogFile
}

# Display the full path of the log file being used
Write-Host "Tracking Explorer paths. Log file location: $logFile"

# Create or clear the log file
Set-Content -Path $logFile -Value "Explorer History Log Started: $(Get-Date)`n"

# Function to get current File Explorer paths
function Get-ExplorerPaths {
    try {
        $shell = New-Object -ComObject Shell.Application
        $paths = @()
        foreach ($window in $shell.Windows()) {
            if ($window -and $window.Name -eq 'File Explorer') {
                $paths += $window.Document.Folder.Self.Path
            }
        }
        return $paths
    }
    catch {
        "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) : Error accessing Explorer windows: $_" | Out-File -Append -FilePath $logFile
    }
}

# Main monitoring loop
$loggedPaths = @{}  # Dictionary to store timestamped paths
while ($true) {
    $currentPaths = Get-ExplorerPaths
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if ($currentPaths.Count -gt 0) {
        foreach ($path in $currentPaths) {
            if (-not $loggedPaths.ContainsKey($path)) {
                if ($SHOW_TIME) {
                    # Log with timestamp and message
                    "$timestamp : New path detected:" | Out-File -Append -FilePath $logFile
                }
                # Always log the path on a separate line
                "  $path" | Out-File -Append -FilePath $logFile
                $loggedPaths[$path] = $true
            }
        }
    } else {
        if ($SHOW_TIME) {
            "$timestamp : No File Explorer window detected" | Out-File -Append -FilePath $logFile
        }
    }

    # Optional: Clear old paths if log grows too large (e.g., after 500 unique entries)
    if ($loggedPaths.Count -gt 500) {
        $loggedPaths.Clear()
        if ($SHOW_TIME) {
            "$timestamp : Path log cleared due to size limit" | Out-File -Append -FilePath $logFile
        }
    }

    Start-Sleep -Seconds $SLEEP_SECONDS
}
