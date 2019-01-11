# Put this into your profile startup script
#
# # directory where my scripts are stored
# 
# $psdir="C:\_SSDWORKSPACE\rootrepo\PowerShell"  
# 
# # load all 'autoload' scripts
# 
# Get-ChildItem "${psdir}\*.ps1" | %{.$_} 
# 
# Write-Host " "  
# 

#Colors
$console = $host.UI.RawUI
$console.ForegroundColor = "white"
$console.BackgroundColor = "black"

$buffer = $console.BufferSize
$buffer.Width = 130
$buffer.Height = 2000
$console.BufferSize = $buffer

$size = $console.WindowSize
$size.Width = 130
$size.Height = 50
$console.WindowSize = $size

#Import-Module $PSScriptRoot\SetConsoleFont.psm1

# $colors = $host.PrivateData
# $colors.VerboseForegroundColor = "white"
# $colors.VerboseBackgroundColor = "blue"
# $colors.WarningForegroundColor = "yellow"
# $colors.WarningBackgroundColor = "darkgreen"
# $colors.ErrorForegroundColor = "white"
# $colors.ErrorBackgroundColor = "red"


cd C:\\_SSDWORKSPACE

Import-Module $PSScriptRoot\PowerTab0.99\PowerTab -ArgumentList "C:\_SSDWORKSPACE\rootrepo\PowerShell\PowerTab0.99\PowerTabConfig.xml"
Import-Module $PSScriptRoot\PowerTabAdb
Import-Module $PSScriptRoot\PowerTabGit

Clear-Host

#UTF-8
Write-Host "Windows PowerShell"
Write-Host "Environment loaded. " -nonewline
#Write-Host "UTF-8: " -nonewline
Write-Host " "
#chcp 65001

##ll
new-alias ll ls

# GREP
new-alias grep findstr

# CAT is an Alias of Get-Content (gc)
#new-alias cat Get-Content

# HEAD
function head{
 param( 
    $a, 
    [Parameter(Mandatory=$false)][int]$b=10)
    cat -TotalCount $b $a
}

#TAIL
function tail{
 param( 
    $a, 
    [Parameter(Mandatory=$false)][int]$b=10,
    [Parameter(Mandatory=$false)][bool]$watch)
    if($watch){
        while (1) {
            cls
            cat -Tail $b $a
            sleep -seconds 2
        }
    }else{
        cat -Tail $b $a
    } 
}

#FIND
function find{
     param($a)
     ls | grep $a
}


#FINDR
function findr{
     param($a)
     Write-Host "Files:"
     gci -recurse -filter "*$a*" -file -ErrorAction SilentlyContinue | foreach-object {
            $place_path = $_.directory
            echo "${place_path}\${_}"
        }
     Write-Host "Directories:"
     gci -recurse -filter "*$a*" -directory -ErrorAction SilentlyContinue 
}

#Search
function search{
    param($a)
    gci -r -i *.* -ErrorAction SilentlyContinue | select-string $a    
}


#top
function top{
    while (1) {
        cls
        ps | sort -desc cpu | select -first 30 | ft -a
        sleep -seconds 2
       }
}

#topm
function topm{
    while (1) {
        cls
        ps | sort -desc ws | select -first 30 | ft -a
        sleep -seconds 2
       }
}

#printenv
function printenv{
    param($a)
    if($a){
        $text = [Environment]::GetEnvironmentVariable($a)
        $text.split(';') | sort | foreach {echo $_} 
    }else{
        gci Env: | sort name
    }
     
}

#set
function set{
    param($a,$b)
    #[Environment]::SetEnvironmentVariable($a,$b, [System.EnvironmentVariableTarget]::User)
    PowerShell '$env:${a}=${b}'
}

#export
function export{
    param($a)
    set($a.split('=')[0], $a.split('=')[1])
}

#unset
function unset{
    param($a)
    [Environment]::SetEnvironmentVariable($a,$null, [System.EnvironmentVariableTarget]::User)
}

#ipinfo
function ip{
    ipconfig | grep IP
}

#sudo
function sudo{
    param($a)
    runas /noprofile /user:EMEA\adm.z123049 "$a"
}

#endless Code
function endlessCode{
    while($true){
    $ProcessIsRunning = Get-Process Code -ErrorAction SilentlyContinue
    if($ProcessIsRunning){
        start-sleep 3
    }else{
        Code
        #cmd.exe /c start /b /min calc.exe
     }
   }
} 

