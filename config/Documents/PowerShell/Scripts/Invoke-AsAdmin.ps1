
$scriptArgs = $args
Start-Process pwsh -ArgumentList '-NoExit', $scriptArgs -Verb 'RunAs' -Wait
