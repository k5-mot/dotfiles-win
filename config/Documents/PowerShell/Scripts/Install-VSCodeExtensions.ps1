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

$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$Test_ExistCommand = $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistCommand "$Test_ExistCommand"

### Install Extensions on VSCode
if (Test-ExistCommand 'code') {
    foreach ($vsext in $vsexts) {
        code --install-extension $vsext
    }
}