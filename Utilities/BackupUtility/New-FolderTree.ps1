# This makes more sense as an example:
#  \\MyComputer\Root\Level1\Level2\Level3
# In the above, [\\MyComputer] already exists, [Root] exists as a share on which 
# the executor has write permissions.
# The requirement is to create the folders Level1.. Level3 
# To emphasise, you must already have permissions on the Root folder above as a share,
# else you may get misleading errors "command not in right format" style, when actually
# the problem is permissions.
# In a real script, I would not have the debug, and the script would take parameters.

function New-FolderTree() {

    $folderTree = "\\dennis-pc1\run\Level1\Level2\Level3\Level4\Level5"
    $x = $folderTree.Split("\");
    "Original Array count: [$($x.Count)]"
    
    $a = New-Object System.Collections.ArrayList
    $a.GetType()
    $a = [System.Collections.ArrayList] $x

    "Original ArrayList count: [$($a.Count)]"
    $a

    $header = $($x[0,1,2,3]) -join '\'
    #shape of the computer + the top level share...
    $header
  
    "Discard the UNC entries, and the computer name, and the top level share, i.e. 4 entries"
    $a.RemoveRange(0,4)
    
    "Updated ArrayList count: [$($a.Count)]"

    "Content of ArrayList:"
    $a

    "Loop around the remaining array to create the required sub-folders"

    $folderToCreate = "$header\"
    1..$a.Count | % {
        $folderToCreate += "$($a[$_-1])\"
        $folderToCreate
        if (!(Test-Path -Path $folderToCreate)) {
            New-Item -ItemType Directory -Path $folderToCreate
        }
    }
}

New-FolderTree
