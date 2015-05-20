#//start: List functions loaded from functions.psm1
$sysfunctions = gci function:
Function myfunctions
{
  gci function: | where {$sysfunctions -notcontains $_} | Select Name
}
#//end

#//start: Display custom menu
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
    1{Start-EMS}
    2{Start-PowerShell}
  # 3{<#run an action or call a function here #>}
  default{Start-PowerShell}
  }
}
#//end

#//start: Launch remote Exchange Management Shell
Function Start-EMS
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
  #Set-Variable -Name SessionStatus -Value 1 -Scope Global
}
#//end

#//start: Launch local PowerShell and close any open remote connections
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
#//end

#//start: Send most current transcript file via email
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
#//end

#//start: Open Windows explorer
Function Explore
{
    ii . 
}
#//end

#//start: Query messaging servers and get uptime
Function Get-Uptime
{
  $file = New-Object System.IO.StreamReader -Arg "\\Aavcmbfil01\Users$\WTSMITH\My Documents\WindowsPowerShell\Arrays\Get-Uptime.txt"
  while ($line = $file.ReadLine()) {
  #// Action to be taken for each line entry begins here
  if ( Test-Connection -ComputerName $line -Count 1 -ErrorAction SilentlyContinue )  
    { 
      $wmi = gwmi Win32_OperatingSystem -computer $line 
       $LBTime = $wmi.ConvertToDateTime($wmi.Lastbootuptime) 
       [TimeSpan]$uptime = New-TimeSpan $LBTime $(get-date) 
       Write-output "$line Uptime is  $($uptime.days) Days $($uptime.hours) Hours $($uptime.minutes) Minutes $($uptime.seconds) Seconds" 
    } 
  else
    { 
      Write-output "$line is not pinging" 
    }
  #// end action
}
$file.close()
}
#//end

#//start: Set personal tags on certain folders in a mailbox
Function Set-PersonalTags
{
  # add EWS Managed API types to shell
  Import-Module "C:\Program Files\Microsoft\Exchange Server\V15\Bin\Microsoft.Exchange.WebServices.dll"

  ##############################################
  ## CONSTANTS START
  ##############################################
  #define mailbox to open
  $impersonatedId = "cortana@obitest.com"

  # hardcode EWS URL to speed things up
  # if we relied on AutoDiscover instead, that would cause an additional call to determine the URL each time this runs
  $ewsEndpoint = [System.Uri] "https://mneexccas01.dev.droot.dmn/ews/exchange.asmx"
  ##############################################
  ## CONSTANTS END
  ##############################################

  # set EWS schema version
  $exchVersion = [Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2013_SP1

  # instantiate the service
  $service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService($exchVersion)

  # set to use current credentials
  # $service.UseDefaultCredentials = $true

  $foo = Get-Credential
  $service.Credentials = New-Object System.Net.NetworkCredential($foo.UserName, $foo.GetNetworkCredential().Password)

  # set the URL
  $service.Url = $ewsEndpoint

  # set the mailbox we want to open
  # $service.ImpersonatedUserId = New-Object Microsoft.Exchange.WebServices.Data.ImpersonatedUserId([Microsoft.Exchange.WebServices.Data.ConnectingIdType]::SmtpAddress, $impersonatedId)

  # get list of tags available to this mailbox
  $retentionTags = $service.GetUserRetentionPolicyTags().RetentionPolicyTags

  foreach ($tag in $retentionTags)
  {
      Write-Host $tag.DisplayName
  }

  # set up the folder search
  $folderView = New-Object Microsoft.Exchange.WebServices.Data.FolderView(200);
  $folderView.Traversal = [Microsoft.Exchange.WebServices.Data.FolderTraversal]::Shallow
  $searchFilter = New-Object Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo([Microsoft.Exchange.WebServices.Data.FolderSchema]::FolderClass, "IPF.Note")  # only find mail folders

  # define which properties to pull to limit the data returned
  $propsToLoad = New-Object Microsoft.Exchange.WebServices.Data.PropertySet(   
    [Microsoft.Exchange.WebServices.Data.FolderSchema]::DisplayName,
    [Microsoft.Exchange.WebServices.Data.FolderSchema]::FolderClass,
    [Microsoft.Exchange.WebServices.Data.FolderSchema]::Id)

  # perform the search
  $folders = $service.FindFolders([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot, $searchFilter, $folderView)

  # walk the folders
  foreach ($folder in $folders.Folders)
  {
    Write-Host $folder.DisplayName $folder.FolderClass
  }
}
#//end