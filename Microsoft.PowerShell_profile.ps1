<#Write-Host "                  ( ( ("                                                                                                                                   
Write-Host "     ___        '. ___ .'       ,,,,,          +++           ===           +++           ###          -*~*-    "     
Write-Host "    (o o)      '  (> <) '      /(o o)\        (o o)         (o o)         (o o)         (o o)         (o o)    "     
Write-Host "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo"
Write-Host ""
Write-Host ""#>
#Write-Host "Press any key to continue ..." -foregroundcolor Cyan
#Write-Progress -Activity "Welcome." -Status "Press Any Key to Continue ..."
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp,AllowCtrlC")
#Write-Host ""

#Write-Host "Setting Global Variables ..." -foregroundcolor DarkGray
Write-Progress -Activity "Initializing" -Status "Setting Global Variables ..."
#Set global variables
$Global:SplitPath = Split-Path $profile
Set-Variable -Name SessionStatus -Value 1 -Scope Global
Set-Variable -Name ResultPath -Value "\\Aavcmbfil01\Users$\WTSMITH\My Documents\WindowsPowerShell\Results\" -Scope Global
#Set-Variable -Name ResultsPath -Value (Split-Path $profile) + "\Results\" -Scope Global
Set-Variable -Name ArrayPath -Value "\\Aavcmbfil01\Users$\WTSMITH\My Documents\WindowsPowerShell\Arrays\" -Scope Global
#//
#Import Custom Functions
#Write-Host "Importing Custom Functions ..." -foregroundcolor DarkGray
Write-Progress -Activity "Initializing" -Status "Importing Custom Functions ..."
Import-Module Functions
#List Custom Functions Loaded from functions.psm1
Write-Host " The following custom functions have been loaded:" -foregroundcolor Cyan
myfunctions
Write-Host ""
Write-Host ""
#Import Custom Modules
#Write-Host "Importing Custom Modules ..." -foregroundcolor DarkGray
Write-Progress -Activity "Initializing" -Status "Importing Custom Modules ..."
#Import-Module PSReadline
#Expand command history buffer
$MaximumHistoryCount = 1024
#Add scripts path to environment variable
$env:path += "C:\Git\PowerShell"
#Add temporary PowerShell drive to be able to CD to scripts easily
#Write-Host "Mapping PSDrive to Scripts Directory ..." -foregroundcolor DarkGray
Write-Progress -Activity "Initializing" -Status "Mapping PSDrive to Scripts Directory ..."
Write-Host " Custom drives have been mapped:" -foregroundcolor Cyan
Write-Host ""
Write-Host "Name"
Write-Host "----"
New-PSDrive -Name "Scripts" -PSProvider FileSystem -Root "C:\Git\PowerShell"
#Aesthetics
Write-Host ""
#Start a transcript for current session
#Write-Host "Starting Transcript ..." -foregroundcolor DarkGray
Write-Progress -Activity "Initializing" -Status "Starting Transcript ..."
Start-Transcript -Append -Force -NoClobber

Write-Host ""
Write-Host " Type 'Menu' if you're lazy. ;)" -foregroundcolor Cyan