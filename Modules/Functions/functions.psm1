Function Send-Email
{
$File = (GCI "C:\FSO" | Sort LastWriteTime -Descending | Select -First 1).FullName
Write-Host "File to be sent: $File"
$SendTo = Read-Host "Send to"
Send-MailMessage -From "Messaging.PowerShell@onebeacon.com" -To $SendTo -Subject "PowerShell Email Delivery" -Attachments $File -SmtpServer relay.internal.local -Body "PowerShell Email Delivery"
} #End Function Send-EMail

Function Close-RemoteSession
{
    Get-PSSession | Remove-PSSession
    cls
    Write-Host " All sessions have been removed. " -foregroundcolor black -backgroundcolor yellow
    Write-Host ""
}

Function Open-RemoteSession
{
    cls
    & $profile
}