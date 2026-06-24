# Sync LAN IP into config.json and run the app on a connected Android phone.
param(
    [string]$DeviceId = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot
$FlutterDir = Split-Path -Parent $ScriptDir

& "$ScriptDir\sync_network_config.ps1"

$config = Get-Content "$FlutterDir\assets\config.json" -Raw | ConvertFrom-Json
$serverUrl = "$($config.physicalApiUrl)/"

Write-Host "Server URL: $serverUrl"
$packageId = "com.example.placeify_flutter"
Write-Host "Uninstalling old app ($packageId) to clear cached server URL..."
if ($DeviceId) {
    adb -s $DeviceId uninstall $packageId 2>$null | Out-Null
} else {
    adb uninstall $packageId 2>$null | Out-Null
}

Push-Location $FlutterDir
try {
    $args = @(
        "run",
        "--dart-define=SERVER_URL=$serverUrl"
    )
    if ($DeviceId) {
        $args += @("-d", $DeviceId)
    }
    flutter @args
} finally {
    Pop-Location
}
