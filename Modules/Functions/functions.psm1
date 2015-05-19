#List functions loaded from functions.psm1
$sysfunctions = gci function:
function myfunctions
{
  gci function: | where {$sysfunctions -notcontains $_} | Select Name
}
#//

Function Menu
{
  Write-Host ""
  #Write-Host " Custom Menu by William Smith " -foregroundcolor Cyan -backgroundcolor DarkGray
  Write-Host "The Lazy Man's Menu"
  Write-Host "-------------------"
  [int]$xMenuChoiceA = 0
  while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 2 ){
  Write-host "1. Exchange Management Shell (Remote Session)"
  Write-host "2. Close Remote Sessions"
  #Write-host "3. Shared mailbox tasks"
  #Write-host "4. Quit and exit"
  Write-Host ""
  [Int]$xMenuChoiceA = read-host "Please choose an option" }
  Switch( $xMenuChoiceA ){
    1{Start-EAC}
    2{Start-PowerShell}
  # 3{<#run an action or call a function here #>}
  default{Start-PowerShell}
  }
}

Function Start-EAC
{
  Write-Host ""
  Write-Host " Welcome to the Exchange Management Shell" -foregroundcolor Cyan
  Write-Host ""
  $server = Read-Host "Enter the Exchange server to connect to"
  Write-Host ""
  $user = Read-Host "Enter your username"
  $pass = Read-Host "Enter your password" -AsSecureString
  $credential = New-Object System.Management.Automation.PSCredential ` -ArgumentList $user,$pass
  $so = New-PSSessionOption -SkipCNCheck -SkipCACheck -SkipRevocationCheck
  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$($server)/powershell" -Authentication Kerberos -Credential $credential -SessionOption $so
  Import-Module (Import-PSSession -DisableNameChecking -Session $Session -AllowClobber) -Global -DisableNameChecking
  Set-ADServerSettings -ViewEntireForest $true
  Write-Host ""
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Verbose
  Write-Host ""
  Set-Variable -Name SessionStatus -Value 1 -Scope Global
}

Function Start-PowerShell
{
  If (!$SessionStatus) {
    Write-Host ""
    Write-Host " No Remote Sessions detected." -foregroundcolor Cyan
    Write-Host " Type 'Menu' for custom functions." -foregroundcolor Cyan
    Write-Host ""
    } 
  Else {
    Get-PSSession | Remove-PSSession
    Write-Host ""
    Write-Host " Remote sessions have been detected and removed." -foregroundcolor Cyan
    Write-Host " Type 'Menu' for custom functions." -foregroundcolor Cyan
    Write-Host ""
    }
  
}

Function Send-Transcript
{
#Stop writing to current transcript
Stop-Transcript
#Aesthetics
Write-Host ""
$File = (GCI "\\Aavcmbfil01\Users$\WTSMITH\My Documents" | Sort LastWriteTime -Descending | Select -First 1).FullName
Write-Host "Transcript to be sent: $File"
$SendTo = Read-Host "Send to"
Send-MailMessage -From "Messaging.PowerShell@onebeacon.com" -To $SendTo -Subject "PowerShell Email Delivery" -Attachments $File -SmtpServer relay.internal.local -Body "PowerShell Email Delivery"
#Aesthetics
Write-Host ""
#Restart writing to a transcript
Start-Transcript -Append -Force -NoClobber
} #End Function Send-Transcript

Function Explore
{
    ii . 
}

Function Get-Uptime
{
    $names = Get-Content "\\Aavcmbfil01\Users$\WTSMITH\My Documents\WindowsPowerShell\Arrays\Get-Uptime.txt"
        @( 
           foreach ($name in $names) 
          { 
            if ( Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue )  
          { 
            $wmi = gwmi Win32_OperatingSystem -computer $name 
            $LBTime = $wmi.ConvertToDateTime($wmi.Lastbootuptime) 
            [TimeSpan]$uptime = New-TimeSpan $LBTime $(get-date) 
            Write-output "$name Uptime is  $($uptime.days) Days $($uptime.hours) Hours $($uptime.minutes) Minutes $($uptime.seconds) Seconds" 
          } 
             else { 
                Write-output "$name is not pinging" 
                  } 
               } 
         ) #| Out-file -FilePath "c:\chethan\results.txt"
}