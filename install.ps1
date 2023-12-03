
function GetTimestamp {
    param ()
    return $(Get-Date -Format "yyyyMMddHHmmssff")
}

function TestAdmin {
    param ()
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = new-object System.Security.Principal.WindowsPrincipal($wid)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $isAdmin = $prp.IsInRole($admin)
    return $isAdmin
}

function PublishSymbolicLink {
    param(
        [Parameter(Mandatory = $true)][string]$target,
        [Parameter(Mandatory = $true)][string]$path,
        [Parameter()][string]$name
    )
    $value = TestAdmin
    if (!$value) {
        Write-Host "Administrative privileges required."
        return
    }
    if ($name -eq "") {
        New-Item -Force -ItemType 'SymbolicLink' -Path $path -Value $target | Out-Null
    }
    else {
        New-Item -Force -ItemType 'SymbolicLink' -Path $path -Name $name -Value $target | Out-Null
    }
}

function TestReparsePoint {
    param (
        [Parameter(Mandatory = $true)][string]$path
    )
    $file = Get-Item $path -Force -ea SilentlyContinue
    return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

Write-Host "Configuration Installation"
$workDir = $(Join-Path "$env:USERPROFILE" 'repos/dotfiles-win')
$configdir = $(Join-Path "$workdir" 'config')

### Install Configs
foreach ($srcpath in $(Get-ChildItem -Path $configdir -Recurse -File).FullName) {
    $dstpath = $(Join-Path "$env:USERPROFILE" $srcpath.Replace($configdir, ''))
    $bakpath = $dstpath + "." + $(GetTimestamp) + ".bak"

    if (Test-Path $dstpath) {
        if (-not (TestReparsePoint $dstpath)) {
            # File except SymbolicLink
            Move-Item $dstpath -Destination $bakpath
            Write-Host "Backup $dstpath" -ForegroundColor "DarkGreen"
        }
    }
    # Copy-Item $srcpath -Destination $dstpath
    PublishSymbolicLink $srcpath $dstpath
    Write-Host "Link $srcpath -> $dstpath" -ForegroundColor "DarkGreen"
}
