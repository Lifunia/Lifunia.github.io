# Instinct 2 / Sauna Timer 0.6.1 の実際のキャプチャに説明用の枠を重ねる。
# 元画像を残しておくことで、撮影結果を変えずに枠の位置だけを調整できる。
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
$raw = Join-Path $root 'assets/images/sauna-timer/raw'
$output = Join-Path $root 'assets/images'
$colors = @{ red = '#ef233c'; blue = '#00b4ee'; green = '#5edb38'; yellow = '#ffe500'; lime = '#b6e51d'; purple = '#8b2ee8'; orange = '#e66a00' }
# 各行は色、x、y、幅、高さ。丸枠は ellipse、必要に応じて回転角度（度）を続ける。
$main = @(
    @('red', 130, 177, 70, 25),
    @('blue', 143, 204, 57, 26),
    @('green', 129, 251, 112, 50),
    @('yellow', 163, 313, 48, 24),
    @('lime', 207, 161, 74, 73, 'ellipse')
)
$frames = @{
    'TOP' = $main
    'Buttons' = @(@('red', 325, 143, 52, 80, 'ellipse', -22), @('blue', 329, 277, 48, 79, 'ellipse', 20), @('purple', 3, 216, 20, 69, 'ellipse', 0), @('orange', 5, 296, 43, 65, 'ellipse', -18))
    'Run' = $main
    'AUFmode' = @($main[0], @('blue', 119, 204, 88, 26), $main[2], $main[3], $main[4])
    'menu' = @(@('red', 133, 243, 110, 29), @('yellow', 178, 318, 18, 11))
    'menu2' = @(@('red', 158, 244, 58, 28), @('yellow', 178, 318, 18, 11))
    'Timermenu' = @(@('green', 152, 234, 62, 24), @('red', 154, 258, 68, 28))
    'PresetTimer' = @(@('blue', 151, 237, 76, 27), @('green', 138, 270, 98, 24))
    'EditTimer' = @(@('green', 132, 264, 112, 26), @('yellow', 153, 301, 70, 17))
    'Setting' = @(@('red', 125, 242, 124, 28), @('yellow', 178, 316, 18, 11))
    'SettingFIT' = @(@('red', 132, 242, 110, 28), @('yellow', 178, 316, 18, 11))
    'Result_set' = @(@('red', 217, 179, 49, 36), @('green', 124, 238, 126, 63), @('yellow', 132, 310, 110, 27))
    'Result_all' = @(@('red', 161, 254, 55, 38), @('yellow', 166, 321, 42, 21))
    'Result' = @(@('red', 218, 178, 48, 41), @('green', 129, 255, 116, 59), @('yellow', 166, 321, 42, 21))
    'History' = @(@('red', 104, 242, 159, 27), @('lime', 213, 167, 57, 58, 'ellipse'))
    'history1' = @(@('blue', 122, 191, 75, 42), @('red', 161, 244, 55, 38), @('green', 160, 287, 53, 22), @('yellow', 166, 321, 42, 21))
    'hisotry2' = @(@('green', 145, 235, 84, 74), @('yellow', 166, 321, 42, 21))
    'Exitmenu' = @(@('green', 131, 176, 70, 54), @('red', 173, 258, 30, 27))
}
foreach ($name in ($frames.Keys | Sort-Object)) {
    $sourceName = if ($name -eq 'Buttons') { 'TOP' } else { $name }
    $bitmap = [System.Drawing.Bitmap]::new((Join-Path $raw "$sourceName.png"))
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
        if ($name -eq 'Buttons') { $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias }
        foreach ($frame in $frames[$name]) {
            $lineWidth = if ($name -eq 'Buttons') { 4 } else { 2 }
            $pen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($colors[$frame[0]]), $lineWidth)
            try {
                if ($frame.Count -gt 5 -and $frame[5] -eq 'ellipse') {
                    if ($frame.Count -gt 6) {
                        $state = $graphics.Save()
                        try {
                            $width = [single]$frame[3]
                            $height = [single]$frame[4]
                            $graphics.TranslateTransform(([single]$frame[1] + $width / 2), ([single]$frame[2] + $height / 2))
                            $graphics.RotateTransform([single]$frame[6])
                            $graphics.DrawEllipse($pen, (-$width / 2), (-$height / 2), $width, $height)
                        } finally { $graphics.Restore($state) }
                    } else {
                        $graphics.DrawEllipse($pen, [int]$frame[1], [int]$frame[2], [int]$frame[3], [int]$frame[4])
                    }
                } else {
                    $graphics.DrawRectangle($pen, [int]$frame[1], [int]$frame[2], [int]$frame[3], [int]$frame[4])
                }
            } finally { $pen.Dispose() }
        }
        $bitmap.Save((Join-Path $output "$name.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    } finally { $graphics.Dispose(); $bitmap.Dispose() }
}
