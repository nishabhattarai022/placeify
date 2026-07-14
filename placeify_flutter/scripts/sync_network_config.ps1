# Writes this PC's current Wi-Fi/Ethernet LAN IP into assets/config.json so
# physical phones can reach the local Serverpod instance.
$ErrorActionPreference = "Stop"

$FlutterDir = Split-Path -Parent $PSScriptRoot
$ConfigFile = Join-Path $FlutterDir "assets\config.json"

$LanIp = (
    Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike "127.*" -and
        $_.IPAddress -notlike "169.254.*" -and
        $_.PrefixOrigin -ne "WellKnown"
    } |
    Sort-Object -Property InterfaceMetric |
    Select-Object -First 1
).IPAddress

if (-not $LanIp) {
    Write-Error "Could not detect LAN IP. Connect to Wi-Fi and retry."
}

$PhysicalUrl = "http://${LanIp}:8080"

$config = @{
    apiUrl = "http://localhost:8080"
    physicalApiUrl = $PhysicalUrl
}

if (Test-Path $ConfigFile) {
    $existing = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    if ($existing.apiUrl) {
        $config.apiUrl = [string]$existing.apiUrl
    }
}

@{
    apiUrl = $config.apiUrl
    physicalApiUrl = $PhysicalUrl
} | ConvertTo-Json | Set-Content $ConfigFile -Encoding utf8

Write-Host "Updated physicalApiUrl -> $PhysicalUrl"
