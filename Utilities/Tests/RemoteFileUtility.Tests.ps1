$Global:configFilePath = "..\Metadata\Friends.spec.json"
Describe "Folder Copy Checks" {
    #https://github.com/pester/Pester/wiki/TestDrive
    MORE WORK REQUIRED
    It "recursively copies files with the specified extension into a single specified folder " { 
        $sourceFolder = "TestDrive:\sourceFolder" # Join-Path "$TestDrive" "empty.txt"
        $sourceSubFolder1 = "$sourceFolder\subFolder1" # Join-Path "$TestDrive" "empty.txt"
        $sourceSubFolder2 = "$sourceFolder\subFolder2" # Join-Path "$TestDrive" "empty.txt"
        New-Item -Path $sourceSubFolder1 -ItemType Directory
        New-Item -Path $sourceSubFolder2 -ItemType Directory

        $files = @{}
        $files["0"] = "file1.filetype1"
        $files["1"] = "file2.filetype1"

        
        Add-PsLogMessage -LogName "YoutubeDemo" -Message $sourceSubFolder1\$($files.Item("0"))

        New-Item -Path $sourceSubFolder1\$($files.Item("0")) -ItemType File

        $y = gci $sourceSubFolder1\$($files.Item("0"))
        Add-PsLogMessage -LogName "YoutubeDemo" -Message $y


        $x = gci $sourceFolder -Recurse

        Add-PsLogMessage -LogName "YoutubeDemo" -Message $x

        try {
            $ranOk = $false
            Check-EmptyFile($emptyFile)
            $ranOk = $true
        }
        catch{}
        $ranOk | Should be $false
    }


}