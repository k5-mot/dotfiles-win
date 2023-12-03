
$file = $(Get-Item $path -Force -ea SilentlyContinue)
[bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)