# add EWS Managed API types to shell
  Import-Module "C:\Program Files\Microsoft\Exchange Server\V15\Bin\Microsoft.Exchange.WebServices.dll"

  ##############################################
  ## CONSTANTS START
  ##############################################
  #define mailbox to open
  $impersonatedId = "cortana@obitest.com"

  # hardcode EWS URL to speed things up
  # if we relied on AutoDiscover instead, that would cause an additional call to determine the URL each time this runs
  $ewsEndpoint = [System.Uri] "https://obitest.onebeacon.com/ews/exchange.asmx"
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
  $folders = $service.FindFolders([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot, <#$searchFilter#>, $folderView)

  # walk the folders
  foreach ($folder in $folders.Folders)
  {
    Write-Host $folder.DisplayName $folder.FolderClass
  }
  
  
#// start: Read array file using Get-Content - deprecated
$names = Get-Content "$ArrayPath" + "Get-Uptime.txt"
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
         ) #| Out-file -FilePath "$ResultsPath" + "Got-Uptime.txt"
#// end

#//start: Read array file line-by-line and act upon each line - performance optimized 
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
             else { 
                Write-output "$line is not pinging" 
                  }
  #// end action
}
$file.close()
#// end

#//start: progress bar example
$events = get-eventlog -logname system
$events | foreach-object -begin {clear-host;$i=0;$out=""} `
-process {if($_.message -like "*bios*") {$out=$out + $_.Message}; $i = $i+1;
write-progress -activity "Searching Events" -status "Progress:" -percentcomplete ($i/$events.count*100)} `
-end {$out}
#//end