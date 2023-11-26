
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


Write-Host "Configuration Installation"
$workDir = $(Join-Path "$env:USERPROFILE" 'repos/dotfiles-win')
$configdir = $(Join-Path "$workdir" 'config')

### Install Configs
foreach ($srcpath in $(Get-ChildItem -Path $configdir -Recurse -File).FullName) {
    $dstpath = $(Join-Path "$env:USERPROFILE" $srcpath.Replace($configdir, ''))
    $bakpath = $dstpath + "." + $(GetTimestamp) + ".bak"

    if (Test-Path $dstpath) {
        if (Test-ReparsePoint $dstpath) {
            # SymbolicLink
            Remove-Item $dstpath
        }
        else {
            # File except SymbolicLink
            Move-Item $dstpath -Destination $bakpath
            Write-Host "Backup $dstpath" -ForegroundColor "DarkGreen"
        }
    }
    # Copy-Item $srcpath -Destination $dstpath
    SymbolicLink -target $srcpath -path $dstpath
    Write-Host "Link $srcpath -> $dstpath" -ForegroundColor "DarkGreen"
}
