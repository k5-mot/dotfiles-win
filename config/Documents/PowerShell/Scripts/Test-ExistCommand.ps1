
$cmdname = $args[0]
[bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
