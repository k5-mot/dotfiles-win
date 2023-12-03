
function Test-Admin {
    param ()
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = new-object System.Security.Principal.WindowsPrincipal($wid)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $isAdmin = $prp.IsInRole($admin)
    return $isAdmin
}

$starterScript = $(Join-Path "$env:TEMP" 'starter.ps1')
$reposDir = $(Join-Path "$env:USERPROFILE" 'repos')
$workDir = $(Join-Path "$reposDir" 'dotfiles-win')
$isAdmin = $(Test-Admin)

if (-not $isAdmin) {

    ### ExecutionPolicy Changed
    if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
    }
    Write-Host "ExecutionPolicy: $(Get-ExecutionPolicy)"

    ### Get Starter Script
    Invoke-WebRequest 'https://raw.githubusercontent.com/k5-mot/dotfiles-win/main/starter.ps1' -OutFile "$starterScript"
    # Copy-Item -Force '.\starter.ps1' "$starterScript"

    ### Run Starter Script on Admin
    if (Test-Path "$starterScript") {
        Start-Process 'powershell.exe' -ArgumentList '-File', "$starterScript" -Verb "RunAs"
        exit 0
    }
}
else {

    ### Required Apps for Installer
    $wingetpkgs = @(
        'Microsoft.PowerShell'
        'Microsoft.WindowsTerminal'
        'Git.Git'
    )

    ### Install Apps via winget
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        foreach ($wingetpkg in $wingetpkgs) {
            winget install --exact --id $wingetpkg
        }
    }

    ### Realod PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

    ### Download dotfiles
    if (-not (Test-Path "$reposDir")) {
        New-Item "$reposDir" -ItemType Directory
    }
    if (-not (Test-Path "$workdir")) {
        git clone --verbose 'https://github.com/k5-mot/dotfiles-win.git' "$workdir"
    }
    Set-Location "$workdir"

    ### Run Installer
    if (Get-Command -Name 'pwsh' -ErrorAction SilentlyContinue) {
        pwsh.exe $(Join-Path "$workdir" 'install.ps1')
        pwsh.exe $(Join-Path "$workdir" 'setup.ps1')
    }
}

exit 1



# if (-not (Test-Path '.\starter.ps1')) {
#     Write-Host "DL"
#     Invoke-WebRequest 'https://raw.githubusercontent.com/k5-mot/dotfiles-win/main/starter.ps1' -OutFile "$env:TEMP\starter.ps1"
# }

# # Start-Process -FilePath 'powershell' -ArgumentList '-File .\starter.ps1' -WorkingDirectory '.'  -Verb RunAs;
# # Start-Process powershell (Get-Content '.\starter.ps1' -Raw) -Verb RunAs;
# # Start-Process powershell (Get-Content '.\starter.ps1' -Raw) -WorkingDirectory (Get-Location) -Verb RunAs;

# # Write-Host (Get-Location)

# ### ExecutionPolicy Changed
# if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
#     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
# }

# if (-not ([System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)))
# {


#     Start-Process powershell -ArgumentList "$env:TEMP\starter.ps1","$(Get-Location)" -Verb RunAs;
#     exit 1
# }


# Write-Host 'ExecutionPolicy:' (Get-ExecutionPolicy)

# ### Required Apps for Installer
# $wingetpkgs = @(
#     'Microsoft.PowerShell'
#     'Microsoft.WindowsTerminal'
#     'Git.Git'
# )

# ### Install Apps via winget
# if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
#     foreach ($wingetpkg in $wingetpkgs) {
#         winget install --exact --id $wingetpkg
#     }
# }

# ### Realod PATH
# $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')

# ### Download dotfiles
# # Remove-Item -Path '.\dotfiles-win' -Recurse -Force
# # cd $HOME
# Write-Host $HOME
# if ((Get-Item .).BaseName -ne 'dotfiles-win') {
#     git clone --verbose 'https://github.com/k5-mot/dotfiles-win.git'
#     Set-Location .\dotfiles-win\
# }

# ### Run Installer
# if (Get-Command -Name 'pwsh' -ErrorAction SilentlyContinue) {
#     pwsh '.\install.ps1'
# }

#     # Start-Process powershell (Invoke-WebRequest "https://raw.githubusercontent.com/k5-mot/dotfiles-win/main/starter.ps1").Content -Verb RunAs;
