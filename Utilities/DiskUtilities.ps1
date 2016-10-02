<#
.Synopsis
   For a named set of servers, determine current space usage
.Description
   For a named set of servers:
   - determine current space usage
   - save the results to an html file (if no file is specified, a file is created in the temp location, with guid name)
   - present the results in a browser window
   Note that although the "nice" fonts are from Google, IE seems a more reliable browser for presenting them
.Example
  "Dennis-PC" , "Jan-PC" | Get-DiskSpace
  "localhost" , "Jan-PC" | Get-DiskSpace
 
#>
Set-StrictMode -Version Latest
function Get-DiskSpace
{
	Param
	(
    	[Parameter(Mandatory=$true,
               	ValueFromPipeline=$true,
               	Position=0)]
    	$ServerSet
	)
 
	Begin {
    	$head = @'
        	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine">
        	<style>
            	head { font-family: 'Tangerine', serif;
                       font-size: 48px;
                	}
      	      body { background-color:lightblue;
                       font-family:Tahoma;
                       font-size:18pt;
             	}
            	p { font-family: 'Tangerine', serif;
                    font-size: 48px;
                	text-align: center;
                    text-shadow: 4px 4px 4px #aaa;
            	}
   	
            	td, th {border: 1px solid black;
                        border-collapse:collapse; }
            	th {color: white;
                    background-color:black; }
           	table, tr, td, th { padding: 1px; margin: 0px }
           	table {margin-left:50px; }
        	</style>
'@
    	$fileName = $env:TEMP + "\"  + [guid]::NewGuid() + ".html"
    	$diskSize = @{Name="Size(GB)";Expression={if ($_.Size -ne $null) {'{0:0.0}' -f ($_.Size/1GB)} else {'N/A'}}}
    	$freeSpace = @{Name="FreeSpace(GB)";Expression={if ($_.FreeSpace -ne $null) {'{0:0.0}' -f ($_.FreeSpace/1GB)} else {'N/A'}}}
    	$percentageFree = @{Name="Percent Free";Expression={'{0:N}' -f ($_.FreeSpace / $_.Size * 100)}}
    	$diskInfo = @()
    	$serverList = [string]::Empty
	}
	Process {
    	"Processing [$ServerSet]..."
    	$diskInfo += Get-CimInstance -ComputerName $ServerSet -ClassName win32_logicaldisk |
        	select SystemName, Name, FileSystem, VolumeName, $diskSize, $freeSpace, $percentageFree 	
	}
	End {
   	$diskInfo | ConvertTo-Html -Head $head -Pre "<p>Disk Usage for the set of servers:[$serverList] [$(Get-Date)]</p><hr/>" -Post "<hr/><p>Fin</p>" |
       	Out-File $FileName; ii $FileName
	}
}
 
