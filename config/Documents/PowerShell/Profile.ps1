
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

function IsAdmin {
    param ()
    $wid  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = (New-Object System.Security.Principal.WindowsPrincipal $wid)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $isAdmin = $prp.IsInRole($admin)
    return $isAdmin
}

### Prompt
function prompt() {
    $isAdmin = IsAdmin
    $color  = if ($isAdmin) {"DarkRed"} else {"DarkCyan"}
    $symbol = if ($isAdmin) {"#"}   else {"$"}
    $username = $env:UserName
    $computername = $env:ComputerName.ToLower()
    $drive = $pwd.Drive.Name
    $path = $pwd.path.Replace($HOME, "~").Replace("${drive}:","")

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
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

### Alias
Set-Alias unzip Expand-Archive
Set-Alias touch New-Item

### Oh-My-Posh
if (IsExistCommand -cmdname 'oh-my-posh') {
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/spaceship.omp.json | Invoke-Expression
}

### PowerShell Module
# URL: https://www.powershellgallery.com/
### PowerShell Modules
$psmodules = @(
    'posh-git'
)
foreach ($psmodule in $psmodules) {
    if (IsExistModule -modulename $psmodule) {
        Import-Module $psmodule
    }
}