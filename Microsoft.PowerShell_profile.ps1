Write-Host "                  ( ( ("                                                                                                                                   
Write-Host "     ___        '. ___ .'       ,,,,,          +++           ===           +++           ###          -*~*-    "     
Write-Host "    (o o)      '  (> <) '      /(o o)\        (o o)         (o o)         (o o)         (o o)         (o o)    "     
Write-Host "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo"
Write-Host "                                                by: Will Smith                                                 "
Write-Host ""
Write-Host "Press any key to continue ..." -foregroundcolor Cyan
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp,AllowCtrlC")
Write-Host ""
#Import Custom Functions
Write-Host "Importing Custom Functions ..." -foregroundcolor DarkGray
Import-Module Functions
#List Custom Functions Loaded from functions.psm1
Write-Host " The following custom functions have been loaded:" -foregroundcolor Cyan
myfunctions
Write-Host ""
#Import Custom Modules
Write-Host "Importing Custom Modules ..." -foregroundcolor DarkGray
#Import-Module PSReadline
#Expand command history buffer
$MaximumHistoryCount = 1024
#Add scripts path to environment variable
$env:path += "C:\Git\PowerShell"
#Add temporary PowerShell drive to be able to CD to scripts easily
Write-Host "Mapping PSDrive to Scripts Directory ..." -foregroundcolor DarkGray
New-PSDrive -Name "Scripts" -PSProvider FileSystem -Root "C:\Git\PowerShell"
#Aesthetics
Write-Host ""
#Start a transcript for current session
Write-Host "Starting Transcript ..." -foregroundcolor DarkGray
Start-Transcript -Append -Force -NoClobber

Write-Host ""
Write-Host " Type 'Menu' if you're lazy. ;)" -foregroundcolor Cyan