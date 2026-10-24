param([string]$AppRoot = 'D:/develop/Sauna-Timer')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$sdk = (Get-Content (Join-Path $env:APPDATA 'Garmin/ConnectIQ/current-sdk.cfg') -Raw).Trim()
$build = Join-Path ([IO.Path]::GetTempPath()) 'lifunia-sauna-screens-062b2'
New-Item -ItemType Directory -Path $build -Force | Out-Null
# A separate ID protects the normal application's history and settings.
$manifest = [IO.File]::ReadAllText((Join-Path $AppRoot 'manifest.xml'))
$manifest = $manifest.Replace('35fe0e9e-c912-4aaf-8753-a2642aa3249e', '2a208459-92e6-4be7-929b-cdf8206f6282').Replace('entry="SaunaApp"', 'entry="ScreenshotApp"')
[IO.File]::WriteAllText((Join-Path $build 'manifest.xml'), $manifest)
$source = (Join-Path $AppRoot 'source').Replace('\', '/')
$fixture = (Join-Path $PSScriptRoot 'sauna-screens/ScreenshotApp.mc').Replace('\', '/')
$resources = (Join-Path $AppRoot 'resources').Replace('\', '/')
$jungle = Join-Path $build 'screens.jungle'
[IO.File]::WriteAllText($jungle, "project.manifest = manifest.xml`nbase.sourcePath = $source;$fixture`nbase.resourcePath = $resources`n")
$program = Join-Path $build 'screens.prg'
& (Join-Path $sdk 'bin/monkeyc.bat') -f $jungle -d instinct2 -y (Join-Path $AppRoot 'developer_key') -r -w -o $program
if ($LASTEXITCODE -ne 0) { throw 'Screenshot fixture build failed' }
# Use the simulator already opened by the user. No clicks or keyboard injection are needed.
& python (Join-Path $PSScriptRoot 'sauna-screens/run-capture.py') (Join-Path $root 'assets/images/sauna-timer/raw') java -classpath (Join-Path $sdk 'bin/monkeybrains.jar') com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f $program -d instinct2 -s (Join-Path $sdk 'bin/shell.exe')
if ($LASTEXITCODE -ne 0) { throw 'Screenshot capture failed' }
