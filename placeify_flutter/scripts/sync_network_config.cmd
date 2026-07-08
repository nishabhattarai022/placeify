@echo off
REM Runs sync_network_config.ps1 without changing system ExecutionPolicy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_network_config.ps1" %*
