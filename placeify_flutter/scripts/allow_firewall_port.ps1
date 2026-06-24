# Run this script in an elevated (Administrator) PowerShell window.
# Allows phones on the same Wi-Fi to reach the local Serverpod instance.
$ErrorActionPreference = "Stop"

$ruleName = "Placeify Serverpod 8080"
$existing = netsh advfirewall firewall show rule name="$ruleName" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Firewall rule already exists: $ruleName"
    exit 0
}

netsh advfirewall firewall add rule `
    name="$ruleName" `
    dir=in `
    action=allow `
    protocol=TCP `
    localport=8080

Write-Host "Added firewall rule: $ruleName"
