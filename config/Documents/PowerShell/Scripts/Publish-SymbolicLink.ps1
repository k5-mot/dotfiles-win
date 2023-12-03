
$profiledir = $(Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
$scriptsdir = $(Join-Path $profiledir 'Scripts')
$cmdscript = $(Join-Path $scriptsdir 'Test-Admin.ps1')
Set-Alias Test-Admin "$cmdscript"

$target = $args[0]
$path = $args[1]
$name = $args[2]
$isAdmin = $(Test-Admin)

if (!$isAdmin) {
    Write-Host "Administrative privileges required."
    return
}
if ($name -eq "") {
    New-Item -ItemType 'SymbolicLink' -Path $path  -Value $target | Out-Null
}
else {
    New-Item -ItemType 'SymbolicLink' -Path $path  -Name $name -Value $target | Out-Null
}