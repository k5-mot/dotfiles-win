### PowerShell Modules
$psmodules = @(
    'posh-git'
    'Terminal-Icons'
    'PSReadLine'
    'CompletionPredictor'
)

$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$Test_ExistPSModule = $(Join-Path $scriptsdir 'Test-ExistPSModule.ps1')
Set-Alias Test-ExistPSModule "$Test_ExistPSModule"

### Install PSModule
foreach ($psmodule in $psmodules) {
    if (-not (Test-ExistPSModule $psmodule)) {
        Install-Module -Name $psmodule -Scope CurrentUser
    }
}