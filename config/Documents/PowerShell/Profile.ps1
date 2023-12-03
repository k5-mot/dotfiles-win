
### Prompt
function prompt() {
    $isAdmin = IsAdmin
    $color = if ($isAdmin) { "DarkRed" } else { "DarkCyan" }
    $symbol = if ($isAdmin) { "#" }   else { "$" }
    $username = $env:UserName
    $computername = $env:ComputerName.ToLower()
    $drive = $pwd.Drive.Name
    $path = $pwd.path.Replace($HOME, "~").Replace("${drive}:", "")

    Write-Host "${username}@${computername}" -ForegroundColor "DarkGreen" -NoNewline
    Write-Host ":" -NoNewline
    Write-Host "${drive}:${path}" -ForegroundColor "DarkBlue"
    Write-Host  "${symbol}" -ForegroundColor $color -NoNewline
    return " "
}

### Encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

### LSColor
$PSStyle.FileInfo.Directory = "`e[33;1m"

### Completion
# 重複した履歴を残さない
Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key "Tab" -Function NextSuggestion
Set-PSReadLineKeyHandler -Key "Shift+Tab" -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Key "Ctrl+r" -Function SwitchPredictionView

### Alias
$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
Set-Alias unzip Expand-Archive
Set-Alias touch New-Item
Set-Alias vi  'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias vim 'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias Edit-Profile             $(Join-Path $scriptsdir 'Edit-Profile.ps1')
Set-Alias Get-Timestamp            $(Join-Path $scriptsdir 'Get-Timestamp.ps1')
Set-Alias Install-Fonts            $(Join-Path $scriptsdir 'Install-Fonts.ps1')
Set-Alias Install-PSModule         $(Join-Path $scriptsdir 'Install-PSModule.ps1')
Set-Alias Install-VSCodeExtensions $(Join-Path $scriptsdir 'Install-VSCodeExtensions.ps1')
Set-Alias Install-WingetPackages   $(Join-Path $scriptsdir 'Install-WingetPackages.ps1')
Set-Alias Install-WSL              $(Join-Path $scriptsdir 'Install-WSL.ps1')
Set-Alias Invoke-AsAdmin           $(Join-Path $scriptsdir 'Invoke-AsAdmin.ps1')
Set-Alias Publish-SymbolicLink     $(Join-Path $scriptsdir 'Publish-SymbolicLink.ps1')
Set-Alias Test-Admin               $(Join-Path $scriptsdir 'Test-Admin.ps1')
Set-Alias Test-ExistCommand        $(Join-Path $scriptsdir 'Test-ExistCommand.ps1')
Set-Alias Test-ExistPSModule       $(Join-Path $scriptsdir 'Test-ExistPSModule.ps1')
Set-Alias Test-ReparsePoint        $(Join-Path $scriptsdir 'Test-ReparsePoint.ps1')
Set-Alias which                    $(Join-Path $scriptsdir 'which.ps1')

### Local Configs
$loaddir = "$env:USERPROFILE\Documents\PowerShell\Autoload"
Get-ChildItem $loaddir | Where-Object Extension -eq ".ps1" | ForEach-Object { .$_.FullName }

### Oh-My-Posh
if (Test-ExistCommand 'oh-my-posh') {
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/spaceship.omp.json | Invoke-Expression
}

# ### PowerShell Module
# # URL: https://www.powershellgallery.com/
# ### PowerShell Modules
$psmodules = @(
    'posh-git'
    'Terminal-Icons'
    'PSReadLine'
    'CompletionPredictor'
)
foreach ($psmodule in $psmodules) {
    if (Test-ExistPSModule $psmodule) {
        Import-Module $psmodule
    }
}