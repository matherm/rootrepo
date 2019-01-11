# requires PowerTab >0.99

$GIT_COMMANDS = `
    "--version",
    "--help",
    "--force",
    "-C",
    "-c",
    "--html-path", 
    "--man-path", 
    "--info-path",
    "-p", 
    "--no-replace-objects", 
    "--bare",
    "--git-dir=<path>", 
    "--work-tree=<path>", 
    "--namespace=<name>",
    "clone",  
    "init",       
    "add",        
    "mv",         
    "reset",      
    "rm",         
    "bisect",     
    "grep",       
    "log",        
    "show",       
    "status",     
    "branch",     
    "checkout",   
    "commit",     
    "diff",       
    "merge",      
    "rebase",     
    "tag",        
    "fetch",      
    "pull",       
    "push"  

function test(){
    echo "abc"
}

$GIT_DESCRIPTIONS = ""

## Git
& {
    Register-TabExpansion "git.exe" -Type "Command" {
        param($Context, [ref]$TabExpansionHasOutput)
        #Write-Host $Context
        if($Context.PositionalParameter -eq 0){
            $TabExpansionHasOutput.Value = $true
            if(-Not($Context.LastWord -eq "")){
                $GIT_COMMANDS = $GIT_COMMANDS| ? {$_.StartsWith($Context.LastWord)}
            }
            $GIT_COMMANDS
        }else{
            $TabExpansionHasOutput.Value = $false
        }
    }.GetNewClosure()
}

Export-ModuleMember -Variable GIT_COMMANDS, GIT_DESCRIPTIONS -Function test  