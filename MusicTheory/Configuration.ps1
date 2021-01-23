function Set-Globals() {
    $Global:stringSet1 = "1", "2", "3", "4", "5", "6" # the strings included in the question sets
    $Global:stringSet2 = "1", "5", "6" # focus on the reference strings
    $Global:stringSet3 = "2", "3", "4" # focus on the non-reference strings
    $Global:stringSet4 = "5", "6" # focus on the reference strings, avoids dominance of 1 and 6 in the same set

    $Global:stringSet = $Global:stringSet1
    $Global:note = "C", "D", "E", "F", "G", "A", "B" # the notes to include in the questions
    $Global:questionCount = 20 # total number of questions per session
    $Global:delayBetweenQuestions = 0 # in seconds
    # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.1
    $Global:fretPerStringNote = @{
        # string 1...
        "1F" = "1"; # read as "string 1, note F... is at fret 1"
        "1G" = "3"; # read as "string 1, note G... is at fret 3", etc.
        "1A" = "5";
        "1B" = "7";
        "1C" = "8";
        "1D" = "a"; # a = 10
        "1E" = "d"; # d = 12
        # string 2...
        "2C" = "1"; 
        "2D" = "3"; 
        "2E" = "5";
        "2F" = "6";
        "2G" = "8";
        "2A" = "a";
        "2B" = "d";
        # string 3...
        "3A" = "2";
        "3B" = "4";
        "3C" = "5"; 
        "3D" = "7"; 
        "3E" = "9";
        "3F" = "a";
        "3G" = "d";
        # string 4...
        "4E" = "2";
        "4F" = "3";
        "4G" = "5";
        "4A" = "7";
        "4B" = "9";
        "4C" = "a"; 
        "4D" = "d"; 
        # string 5...
        "5B" = "2"; 
        "5C" = "3"; 
        "5D" = "5";
        "5E" = "7";
        "5F" = "8";
        "5G" = "a";
        "5A" = "d";
        # string 6...
        "6F" = "1"; 
        "6G" = "3"; 
        "6A" = "5";
        "6B" = "7";
        "6C" = "8";
        "6D" = "a";
        "6E" = "d";
    }
    $Global:duplicatesOk = $true
    $Global:speech = $null

    $Global:pollyStringSequence = "3","6","1","2","5","4"
}
 