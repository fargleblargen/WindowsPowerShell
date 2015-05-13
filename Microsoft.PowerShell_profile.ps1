Write-Host " Welcome to the Exchange Management Shell " -foregroundcolor black -backgroundcolor green
Write-Host ""
$server = Read-Host "Enter the Exchange server to connect to"
Write-Host ""
$user = Read-Host "Enter your username"
$pass = Read-Host "Enter your password" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential ` -ArgumentList $user,$pass
$so = New-PSSessionOption -SkipCNCheck -SkipCACheck -SkipRevocationCheck
$Exchange2013 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri “http://$($server)/powershell” -Credential $credential -SessionOption $so
Import-PSSession -DisableNameChecking -Session $Exchange2013
Set-ADServerSettings -ViewEntireForest $true
#Import-Module ActiveDirectory -DisableNameChecking
#Import-Module C:\Scripts\functions.psm1
Import-Module Functions
#Import-Module PSGet
Import-Module PSReadline


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Rikard Ronnkvist / snowland.se
# Multicolored prompt with marker for windows started as Admin and marker for providers outside filesystem
# Examples
# C:\Windows\System32>
# [Admin] C:\Windows\System32>
# [Registry] HKLM:\SOFTWARE\Microsoft\Windows>
# [Admin] [Registry] HKLM:\SOFTWARE\Microsoft\Windows>
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function prompt
{
# New nice WindowTitle
$Host.UI.RawUI.WindowTitle = "PowerShell v" + (get-host).Version.Major + "." + (get-host).Version.Minor + " (" + $pwd.Provider.Name + ") " + $pwd.Path
# Admin ?
if( (
New-Object Security.Principal.WindowsPrincipal (
[Security.Principal.WindowsIdentity]::GetCurrent())
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
# Admin-mark in WindowTitle
$Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle
# Admin-mark on prompt
Write-Host "[" -nonewline -foregroundcolor DarkGray
Write-Host "Admin" -nonewline -foregroundcolor Red
Write-Host "] " -nonewline -foregroundcolor DarkGray
}
# Show providername if you are outside FileSystem
if ($pwd.Provider.Name -ne "FileSystem") {
Write-Host "[" -nonewline -foregroundcolor DarkGray
Write-Host $pwd.Provider.Name -nonewline -foregroundcolor Gray
Write-Host "] " -nonewline -foregroundcolor DarkGray
}
# Split path and write \ in a gray
$pwd.Path.Split("\") | foreach {
Write-Host $_ -nonewline -foregroundcolor White
Write-Host "\" -nonewline -foregroundcolor Gray
}
# Backspace last \ and write >
Write-Host "`b>" -nonewline -foregroundcolor Gray
return " "
}
