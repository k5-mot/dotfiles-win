### PowerShell Modules
$psmodules = @(
    'posh-git'
)

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
)

### Fonts
$fonts = @(
    'CascadiaCode'
    'CascadiaMono'
    'FiraCode'
    'FiraMono'
    'Meslo'
)

### VSCode Extensions
$vsexts = @(
    'formulahendry.auto-rename-tag'
    'ms-vscode.cpptools'
    'ms-vscode.cpptools-extension-pack'
    'ms-azuretools.vscode-docker'
    'dsznajder.es7-react-js-snippets'
    'dbaeumer.vscode-eslint'
    'eamodio.gitlens'
    'visualstudioexptteam.vscodeintellicode'
    'ms-toolsai.jupyter'
    'ms-vscode.live-server'
    'ritwickdey.liveserver'
    'ms-vsliveshare.vsliveshare'
    'yzhang.markdown-all-in-one'
    'zhuangtongfa.material-theme'
    'ms-vscode.powershell'
    'esbenp.prettier-vscode'
    'ms-python.python'
    'ms-python.vscode-pylance'
    'ms-vscode-remote.vscode-remote-extensionpack'
    'ms-vscode.remote-explorer'
    'pkief.material-icon-theme'
    'shd101wyy.markdown-preview-enhanced'
    'christian-kohler.path-intellisense'
)

Write-Host "Setup Development Environment"

### ExecutionPolicy Changed
if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
}
Write-Host 'ExecutionPolicy:' (Get-ExecutionPolicy)

### PSRepositoryPolicy Changed
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}
Write-Host 'InstallationPolicy:' ((Get-PSRepository -Name PSGallery).InstallationPolicy)

### Install Apps via winget
if (IsExistCommand -cmdname 'winget') {
    foreach ($wingetpkg in $wingetpkgs) {
        winget install --exact --id  $wingetpkg
    }
}

### Install Font for Oh-My-Posh
if (IsExistCommand -cmdname 'oh-my-posh') {
    foreach ($font in $fonts) {
        oh-my-posh font install --user $font
    }
}

### Install Extensions on VSCode
if (IsExistCommand -cmdname 'code') {
    foreach ($vsext in $vsexts) {
        code --install-extension $vsext
    }
}

### Install PSModule
foreach ($psmodule in $psmodules) {
    if (-not (IsExistModule -modulename $psmodule)) {
        Install-Module -Name $psmodule -Scope CurrentUser
    }
}

### Setup WSL
if (IsExistCommand -cmdname 'wsl') {
    wsl --update
    wsl --version
    wsl --install 'Ubuntu' --no-launch
    # wsl --distribution 'Ubuntu'
}