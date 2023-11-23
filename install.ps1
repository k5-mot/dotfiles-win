
Write-Host "Configuration Installation"
$workdir = $(Join-Path "$env:TEMP" 'dotfiles-win')
$configdir = $(Join-Path "$workdir" 'config')

### Install Configs
# Get-ChildItem -Path '.\config' -Recurse -File | ForEach-Object { $_.FullName.Replace($workdir, "") }

function GetTimestamp {
    param ()
    return $(Get-Date -Format "yyyyMMddHHmmssff")
}

foreach ($srcpath in $(Get-ChildItem -Path $configdir -Recurse -File).FullName) {
    $dstpath = $(Join-Path "$env:USERPROFILE" $srcpath.Replace($configdir, ''))
    $bakpath = $dstpath + "." + $(GetTimestamp) + ".bak"

    Write-Host $srcpath
    Write-Host $dstpath
    Write-Host $bakpath
    if (Test-Path $dstpath) {
        Move-Item $dstpath -Destination $bakpath
        Write-Host "Backup $dstpath to $bakpath"
    }
    Copy-Item $srcpath -Destination $dstpath
    Write-Host "Copy $srcpath to $dstpath"
}
Pause
