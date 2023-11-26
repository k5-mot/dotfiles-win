
### Function
function which {
    param ($exefile)
    return (Get-Command $exefile).Definition
}

function EditProfile {
    if (IsExistCommand -cmdname 'code') {
        code $PROFILE.CurrentUserAllHosts
    }
    else {
        Get-Content $PROFILE.CurrentUserAllHosts
    }
    return ($PROFILE.CurrentUserAllHosts)
}

function IsExistCommand {
    param ($cmdname)
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function IsExistModule {
    param ($modulename)
    return [bool](Get-InstalledModule -Name $modulename -ErrorAction SilentlyContinue)
}

function GetTimestamp {
    param ()
    return $(Get-Date -Format "yyyyMMddHHmmssff")
}

function IsAdmin {
    param ()
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = new-object System.Security.Principal.WindowsPrincipal($wid)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $isAdmin = $prp.IsInRole($admin)
    return $isAdmin
}

function SymbolicLink {
    param(
        [Parameter(Mandatory = $true)][string]$target,
        [Parameter(Mandatory = $true)][string]$path,
        [Parameter()][string]$name
    )
    $value = IsAdmin
    if (!$value) {
        Write-Host "Administrative privileges required."
        return
    }
    if ($name -eq "") {
        New-Item -ItemType 'SymbolicLink' -Path $path  -Value $target | Out-Null
    }
    else {
        New-Item -ItemType 'SymbolicLink' -Path $path  -Name $name -Value $target | Out-Null
    }
}

function Test-ReparsePoint {
    param (
        [Parameter(Mandatory = $true)][string]$path
    )
    $file = Get-Item $path -Force -ea SilentlyContinue
    return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}


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
# Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete


### Alias
Set-Alias unzip Expand-Archive
Set-Alias touch New-Item
Set-Alias vi  'C:\Program Files\Vim\vim90\vim.exe'
Set-Alias vim 'C:\Program Files\Vim\vim90\vim.exe'

### Oh-My-Posh
if (IsExistCommand -cmdname 'oh-my-posh') {
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/spaceship.omp.json | Invoke-Expression
}

### PowerShell Module
# URL: https://www.powershellgallery.com/
### PowerShell Modules
$psmodules = @(
    'posh-git'
    'Terminal-Icons'
    'PSReadLine'
    'CompletionPredictor'
)
foreach ($psmodule in $psmodules) {
    if (IsExistModule -modulename $psmodule) {
        Import-Module $psmodule
    }
}