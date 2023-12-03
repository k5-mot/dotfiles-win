### Fonts
$fonts = @(
    'CascadiaCode'
    'CascadiaMono'
    'FiraCode'
    'FiraMono'
    'Meslo'
)

$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$Test_ExistCommand = $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistCommand "$Test_ExistCommand"

### Install Font for Oh-My-Posh
if (Test-ExistCommand 'oh-my-posh') {
    foreach ($font in $fonts) {
        oh-my-posh font install --user $font
    }
}