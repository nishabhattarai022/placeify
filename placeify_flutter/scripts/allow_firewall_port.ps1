# Run this script in an elevated (Administrator) PowerShell window.
# Allows phones on the same Wi-Fi to reach the local Serverpod instance.
$ErrorActionPreference = "Stop"

$rules = @(
    @{ Name = "Placeify Serverpod 8080"; Port = 8080 },
    @{ Name = "Placeify Serverpod 8082"; Port = 8082 }
)

foreach ($rule in $rules) {
    $existing = netsh advfirewall firewall show rule name="$($rule.Name)" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Firewall rule already exists: $($rule.Name)"
        continue
    }

    netsh advfirewall firewall add rule `
        name="$($rule.Name)" `
        dir=in `
        action=allow `
        protocol=TCP `
        localport=$($rule.Port)

    Write-Host "Added firewall rule: $($rule.Name)"
}
