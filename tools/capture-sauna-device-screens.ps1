param([string]$AppRoot = 'D:/develop/Sauna-Timer', [ValidateSet('fr965', 'fenix7')][string]$Device = 'fr965')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$sdk = (Get-Content (Join-Path $env:APPDATA 'Garmin/ConnectIQ/current-sdk.cfg') -Raw).Trim()
$build = Join-Path ([IO.Path]::GetTempPath()) "lifunia-sauna-071-$Device"
New-Item -ItemType Directory -Path $build -Force | Out-Null
# Keep all generated files outside the app repository and isolate fixture storage.
$manifest = [IO.File]::ReadAllText((Join-Path $AppRoot 'manifest.xml'))
$manifest = $manifest.Replace('35fe0e9e-c912-4aaf-8753-a2642aa3249e', '821853b3-320d-48dc-a930-dea9b123bb71').Replace('entry="SaunaApp"', 'entry="DeviceScreensApp"')
[IO.File]::WriteAllText((Join-Path $build 'manifest.xml'), $manifest)
$source = (Join-Path $AppRoot 'source').Replace('\', '/')
$fixture = (Join-Path $PSScriptRoot 'sauna-device-screens/DeviceScreens.mc').Replace('\', '/')
$resources = (Join-Path $AppRoot 'resources/common').Replace('\', '/')
$deviceResources = (Join-Path $AppRoot "resources/devices/$Device").Replace('\', '/')
$jungle = Join-Path $build 'screens.jungle'
[IO.File]::WriteAllText($jungle, "project.manifest = manifest.xml`nbase.sourcePath = $source;$fixture`nbase.resourcePath = $resources;$deviceResources`nbase.excludeAnnotations = forerunnerLayout;historyStackedFooter`nround.excludeAnnotations = instinctLayout;historyStackedFooter`n")
$program = Join-Path $build 'screens.prg'
& (Join-Path $sdk 'bin/monkeyc.bat') -f $jungle -d $Device -y (Join-Path $AppRoot 'developer_key') -r -w -o $program
if ($LASTEXITCODE -ne 0) { throw 'Screenshot fixture build failed' }
if (!(Get-Process simulator -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath (Join-Path $sdk 'bin/simulator.exe') -WindowStyle Hidden
    Start-Sleep -Seconds 3
}
& python (Join-Path $PSScriptRoot 'sauna-device-screens/run-capture.py') (Join-Path $root "assets/images/sauna-timer/raw/$Device") java -classpath (Join-Path $sdk 'bin/monkeybrains.jar') com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f $program -d $Device -s (Join-Path $sdk 'bin/shell.exe')
if ($LASTEXITCODE -ne 0) { throw 'Screenshot capture failed' }
