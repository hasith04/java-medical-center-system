# Copy built web app into Tomcat webapps
# Run scripts\build.ps1 first.

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$WebRoot = Join-Path $Root "MedicalCentre\web"
$AppName = "MedicalCentre"

if (-not $env:TOMCAT_HOME) {
    Write-Error "Set TOMCAT_HOME to your Tomcat folder"
}

$Dest = Join-Path $env:TOMCAT_HOME "webapps\$AppName"
if (Test-Path $Dest) {
    Write-Host "Removing old deployment at $Dest"
    Remove-Item $Dest -Recurse -Force
}

Write-Host "Deploying to $Dest"
Copy-Item $WebRoot $Dest -Recurse
Write-Host "Deployed. Start Tomcat and open http://localhost:8080/$AppName/"
