
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

### SSH Key Gen
if (-not (Test-Path "$env:USERPROFILE\.ssh\id_rsa")) {
    ssh-keygen -t rsa -b 4096 -C "SSH Key on Windows"
}

. $(Join-Path $scriptsdir 'Install-WingetPackages.ps1')
. $(Join-Path $scriptsdir 'Install-Fonts.ps1')
. $(Join-Path $scriptsdir 'Install-VSCodeExtensions.ps1')
. $(Join-Path $scriptsdir 'Install-PSModule.ps1')
. $(Join-Path $scriptsdir 'Install-WSL.ps1')
