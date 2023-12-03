### Winget Packages
$wingetpkgs = @(
    'Microsoft.PowerShell'
    'Microsoft.WindowsTerminal'
    'Microsoft.VisualStudioCode'
    'Git.Git'
    'JanDeDobbeleer.OhMyPosh'
    'OpenJS.NodeJS'
    'Python.Python.3.9'
    'OBSProject.OBSStudio'
    'NickeManarin.ScreenToGif'
    'TortoiseGit.TortoiseGit'
    'vim.vim'
    'Neovim.Neovim'
)

$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$Test_ExistCommand = $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistCommand "$Test_ExistCommand"

### Install Apps via winget
if (Test-ExistCommand 'winget') {
    foreach ($wingetpkg in $wingetpkgs) {
        winget install --exact --id $wingetpkg
    }
}