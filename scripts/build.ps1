# Build MedicalCentre WAR layout: compile Java -> WEB-INF/classes
# Prerequisites:
#   - JDK 8+ (java, javac on PATH)
#   - TOMCAT_HOME set to your Apache Tomcat install folder
#   - MySQL JDBC driver in MedicalCentre\web\WEB-INF\lib\ (any mysql-connector*.jar)

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$WebRoot = Join-Path $Root "MedicalCentre\web"
$SrcRoot = Join-Path $Root "MedicalCentre\java"
$ClassesDir = Join-Path $WebRoot "WEB-INF\classes"
$LibDir = Join-Path $WebRoot "WEB-INF\lib"

if (-not $env:TOMCAT_HOME) {
    Write-Error "Set TOMCAT_HOME to your Tomcat folder (e.g. C:\apache-tomcat-9.0.98)"
}

$ServletApi = Join-Path $env:TOMCAT_HOME "lib\servlet-api.jar"
if (-not (Test-Path $ServletApi)) {
    Write-Error "servlet-api.jar not found at $ServletApi - check TOMCAT_HOME"
}

$JdbcJar = Get-ChildItem $LibDir -Filter "mysql-connector*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $JdbcJar) {
    Write-Error "Put mysql-connector-java*.jar in $LibDir"
}

New-Item -ItemType Directory -Force -Path $ClassesDir | Out-Null

$JavaFiles = Get-ChildItem $SrcRoot -Recurse -Filter "*.java"
Write-Host "Compiling $($JavaFiles.Count) Java files..."

$classpath = (Get-ChildItem $LibDir -Filter "*.jar" | ForEach-Object { $_.FullName }) -join ";"
$classpath = "$ServletApi;$classpath"
javac -encoding UTF-8 -cp $classpath -d $ClassesDir $JavaFiles.FullName

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Build OK. Classes in $ClassesDir"
