Function RunOn-Windows
{
Write-Host 'The Script is Running on a Windows Machine'
}

Function RunOn-Linux
{
Write-Host 'The Script is Running on a Linux Machine'
}

Function RunOn-Mac
{
Write-Host 'The Script is Running on a Mac'
}

If ($IsWindows) {RunOn-Windows}
If ($IsLinux) {RunOn-Linux}
If ($IsMacOS) {RunOn-Mac}



[System.IO.Path]::GetTempPath()+"\Porvoo.db"