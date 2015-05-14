Function Menu
{
  Write-Host ""
  Write-Host " Custom Menu by William Smith " -foregroundcolor white -backgroundcolor blue
  Write-Host ""
  [int]$xMenuChoiceA = 0
  while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 2 ){
  Write-host "1. Exchange Management Shell (Remote Session)"
  Write-host "2. Windows PowerShell"
  #Write-host "3. Shared mailbox tasks"
  #Write-host "4. Quit and exit"
  Write-Host ""
  [Int]$xMenuChoiceA = read-host "Please choose an option" }
  Switch( $xMenuChoiceA ){
    1{Start-EAC}
    2{Start-PowerShell}
  # 3{<#run an action or call a function here #>}
  default{<#run a default action or call a function here #>}
  }
}
Function Send-Transcript
{
$File = (GCI "\\Aavcmbfil01\Users$\WTSMITH\My Documents" | Sort LastWriteTime -Descending | Select -First 1).FullName
Write-Host "Transcript to be sent: $File"
$SendTo = Read-Host "Send to"
Send-MailMessage -From "Messaging.PowerShell@onebeacon.com" -To $SendTo -Subject "PowerShell Email Delivery" -Attachments $File -SmtpServer relay.internal.local -Body "PowerShell Email Delivery"
} #End Function Send-Transcript

Function Close-RemoteSession
{
    Get-PSSession | Remove-PSSession
    cls
    Write-Host " Remote sessions have been removed. " -foregroundcolor black -backgroundcolor yellow
    Write-Host ""
}

Function Open-RemoteSession
{
    cls
    & $profile
}

Function Explore
{
    ii . 
}

Function Start-EAC
{
  Write-Host ""
  Write-Host " Welcome to the Exchange Management Shell " -foregroundcolor black -backgroundcolor green
  Write-Host ""
  $server = Read-Host "Enter the Exchange server to connect to"
  Write-Host ""
  $user = Read-Host "Enter your username"
  $pass = Read-Host "Enter your password" -AsSecureString
  $credential = New-Object System.Management.Automation.PSCredential ` -ArgumentList $user,$pass
  $so = New-PSSessionOption -SkipCNCheck -SkipCACheck -SkipRevocationCheck
  $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$($server)/powershell" -Credential $credential -SessionOption $so
  $MaximumHistoryCount = 1024
  Import-PSSession -DisableNameChecking -Session $session
  Set-ADServerSettings -ViewEntireForest $true
  Write-Host ""
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Verbose
  Write-Host ""
  Start-Transcript -Append -Force -NoClobber
  #Import-Module ActiveDirectory -DisableNameChecking
  #Import-Module C:\Scripts\functions.psm1
  Import-Module Functions
  #Import-Module PSGet
  Import-Module PSReadline
}

Function Start-PowerShell
{
  Get-PSSession | Remove-PSSession
  Write-Host ""
  Write-Host " Welcome to PowerShell. Remote sessions have been removed. " -foregroundcolor black -backgroundcolor green
  Write-Host ""
}