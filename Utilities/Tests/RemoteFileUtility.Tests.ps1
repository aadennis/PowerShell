. ../LogUtility/LogUtility.ps1

Describe "Folder Copy Checks" {
    #https://github.com/pester/Pester/wiki/TestDrive
    It "recursively copies files with the specified extension into a single specified folder " { 
        $sourceFolder = "$TestDrive" # Join-Path "$TestDrive" "empty.txt"
        $sourceSubFolder1 = "$sourceFolder\subFolder1" # Join-Path "$TestDrive" "empty.txt"
        $sourceSubFolder2 = "$sourceFolder\subFolder2" # Join-Path "$TestDrive" "empty.txt"
        New-Item -Path $sourceSubFolder1 -ItemType Directory
        New-Item -Path $sourceSubFolder2 -ItemType Directory

        $files = @{}
        $files["0"] = "file1.filetype0"
        $files["1"] = "file2.filetype1"
        $files["2"] = "file3.filetype2"
        $files["3"] = "file4.filetype3"
        $files["4"] = "file5.filetype4"
        
        foreach ($file in $files.Values) {
            New-Item -Path $sourceSubFolder1\$file -ItemType File
            New-Item -Path $sourceSubFolder2\$file -ItemType File
        } 

        Get-ChildItem -Path $sourceFolder -Recurse  | ForEach-Object { Add-PsLogMessage -LogName "YoutubeDemo" -Message $($_.FullName)}
    }


}