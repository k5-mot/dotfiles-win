
$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$cmdscript = $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistCommand "$cmdscript"

if (Test-ExistCommand 'code') {
    code $PROFILE.CurrentUserAllHosts
}
else {
    Get-Content $PROFILE.CurrentUserAllHosts
}
[string]($PROFILE.CurrentUserAllHosts)