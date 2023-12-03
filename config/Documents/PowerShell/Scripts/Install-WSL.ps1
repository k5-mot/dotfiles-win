$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$Test_ExistCommand = $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistCommand "$Test_ExistCommand"


### Setup WSL
if (Test-ExistCommand 'wsl') {
    wsl --update
    wsl --version
    wsl --install 'Ubuntu' --no-launch
    # wsl --distribution 'Ubuntu'
}