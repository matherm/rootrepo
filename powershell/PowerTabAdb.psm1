# requires PowerTab >0.99

$ADB_COMMANDS = `
    "-a",
    "-d",
    "-e",
    "-s",                   
    "-p",              
    "-H",                                     
    "-P",                                     
    "devices",                           
    "connect",                
    "disconnect",           
    "push",
    "pull",
    "sync",                   
    "shell",                        
    "emu",                          
    "logcat",               
    "forward",                         
    "reverse",                         
    "jdwp",                                   
    "install",               
    "uninstall",               
    "bugreport",                              
    "enable-verity",                          
    "keygen",                          
    "help",                                   
    "version",                                
    "wait-for-device",                        
    "start-server",                           
    "kill-server",                            
    "get-state",                              
    "get-serialno",                           
    "get-devpath",                            
    "remount",                                
    "reboot",
    "sideload",                        
    "root",                                   
    "unroot",                                 
    "usb",                                    
    "tcpip",                           
    "ppp"

$ADB_DESCRIPTIONS =  ""

function test(){
    echo "abc"
}

## adb
& {
    Register-TabExpansion "adb.exe" -Type "Command" {
        param($Context, [ref]$TabExpansionHasOutput)
          if($Context.PositionalParameter -eq 0){
            $TabExpansionHasOutput.Value = $true
            if(-Not($Context.LastWord -eq "")){
                $ADB_COMMANDS = $ADB_COMMANDS| ? {$_.StartsWith($Context.LastWord)}
            }
            $ADB_COMMANDS
        }else{
            $TabExpansionHasOutput.Value = $false
        }
    }.GetNewClosure()
}

Export-ModuleMember -Variable ADB_COMMANDS, ADB_DESCRIPTIONS  -Function test  