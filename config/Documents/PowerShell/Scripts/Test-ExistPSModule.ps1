
$modulename = $args[0]
[bool](Get-InstalledModule -Name $modulename -ErrorAction SilentlyContinue)