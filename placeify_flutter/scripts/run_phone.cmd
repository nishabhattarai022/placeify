@echo off
REM Sync LAN IP, clear cached server URL, and run on a connected Android phone.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_phone.ps1" %*
