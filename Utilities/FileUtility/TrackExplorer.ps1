# Track folders visited by File Explorer,
# pausing for n seconds before comparing old and current locations.
# Todo - add support for the Files app

$logFile = "D:\sandbox\ExplorerHistory_Simplified.txt"
$SLEEP_SECONDS = 5

# Create or clear the file if it exists
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
$lastPaths = @()
while ($true) {
    $currentPaths = Get-ExplorerPaths
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if ($currentPaths.Count -gt 0) {
        foreach ($path in $currentPaths) {
            if ($path -notin $lastPaths) {
                "$timestamp : New path detected: $path" | Out-File -Append -FilePath $logFile
            }
        }
        $lastPaths = $currentPaths
    }
    else {
        "$timestamp : No File Explorer window detected" | Out-File -Append -FilePath $logFile
    }

    Start-Sleep -Seconds $SLEEP_SECONDS
}

