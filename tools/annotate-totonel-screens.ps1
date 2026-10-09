# ととねる0.1.2の実キャプチャに、ページの操作説明と対応する枠を重ねる。
# PNGは未加工で保存し、表示範囲と注釈はSVGだけで管理する。
$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path $PSScriptRoot -Parent
$imageDirectory = Join-Path $siteRoot 'assets/images'
$colors = @{ red = '#ff1726'; blue = '#4645df'; cyan = '#00a9ce'; green = '#1bb84c'; orange = '#ff8426'; purple = '#ab47bc'; pink = '#ed74a8' }
# 座標は1080x2400の元キャプチャ基準。OSのステータスバーとナビゲーションバーは表示範囲から外す。
$frames = @{
    'totonel-detail' = @(
        @('red', 246, 292, 588, 142),
        @('blue', 102, 1170, 420, 120),
        @('cyan', 574, 1170, 419, 120),
        @('green', 663, 532, 88, 84),
        @('orange', 763, 532, 88, 84),
        @('purple', 869, 523, 105, 105),
        @('purple', 869, 1413, 105, 105),
        @('pink', 83, 2013, 861, 296)
    )
    'totonel-set-delete' = @(
        @('red', 158, 1074, 766, 435),
        @('blue', 704, 1558, 216, 139)
    )
}
foreach ($name in ($frames.Keys | Sort-Object)) {
    $encodedImage = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $imageDirectory "$name.png")))
    $svg = [Text.StringBuilder]::new()
    [void]$svg.AppendLine('<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="2220" viewBox="0 112 1080 2220">')
    [void]$svg.AppendLine("<image x=`"0`" y=`"0`" width=`"1080`" height=`"2400`" href=`"data:image/png;base64,$encodedImage`"/>")
    [void]$svg.AppendLine('<g fill="none" stroke-width="5">')
    foreach ($frame in $frames[$name]) {
        [void]$svg.AppendLine("<rect x=`"$($frame[1])`" y=`"$($frame[2])`" width=`"$($frame[3])`" height=`"$($frame[4])`" stroke=`"$($colors[$frame[0]])`"/>")
    }
    [void]$svg.AppendLine('</g>')
    [void]$svg.AppendLine('</svg>')
    [IO.File]::WriteAllText((Join-Path $imageDirectory "$name.svg"), $svg.ToString(), [Text.UTF8Encoding]::new($false))
}
