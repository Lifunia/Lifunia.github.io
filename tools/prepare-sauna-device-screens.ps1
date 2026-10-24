param([ValidateSet('fr965', 'fenix7')][string[]]$Devices = @('fr965', 'fenix7'))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
$annotations = Get-Content (Join-Path $PSScriptRoot 'sauna-device-screens/annotations.json') -Raw | ConvertFrom-Json
$colors = @{ red = '#ef233c'; blue = '#00b4ee'; green = '#5edb38'; yellow = '#ffe500'; lime = '#b6e51d'; purple = '#8b2ee8'; orange = '#e66a00' }
foreach ($device in $Devices) {
    $raw = Join-Path $root "assets/images/sauna-timer/raw/$device"
    $output = Join-Path $root "assets/images/sauna-timer/$device"
    New-Item -ItemType Directory -Path $output -Force | Out-Null
    foreach ($entry in $annotations.$device.PSObject.Properties) {
        $name = $entry.Name
        # Buttons gets its own annotation layer over the same unmodified TOP capture.
        $sourceName = if ($name -eq 'Buttons') { 'TOP' } else { $name }
        $source = [System.Drawing.Bitmap]::new((Join-Path $raw "$sourceName.png"))
        try {
            # Standard Windows simulator chrome: 8px side borders, 52px header, 34px footer.
            $crop = [System.Drawing.Rectangle]::new(8, 52, $source.Width - 16, $source.Height - 86)
            $height = [int][Math]::Round(382 * $crop.Height / $crop.Width)
            $target = [System.Drawing.Bitmap]::new(382, $height)
            $graphics = [System.Drawing.Graphics]::FromImage($target)
            try {
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.DrawImage($source, [System.Drawing.Rectangle]::new(0, 0, 382, $height), $crop, [System.Drawing.GraphicsUnit]::Pixel)
                # Coordinates are in final 382px-wide image pixels, with padding around text.
                foreach ($frame in $entry.Value) {
                    $lineWidth = if ($name -eq 'Buttons') { 3 } else { 2 }
                    $pen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($colors[$frame[0]]), $lineWidth)
                    try {
                        if ($frame.Count -gt 5 -and $frame[5] -eq 'ellipse') {
                            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
                            $graphics.DrawEllipse($pen, [int]$frame[1], [int]$frame[2], [int]$frame[3], [int]$frame[4])
                        } else {
                            $graphics.DrawRectangle($pen, [int]$frame[1], [int]$frame[2], [int]$frame[3], [int]$frame[4])
                        }
                    } finally { $pen.Dispose() }
                }
                $target.Save((Join-Path $output "$name.png"), [System.Drawing.Imaging.ImageFormat]::Png)
            } finally { $graphics.Dispose(); $target.Dispose() }
        } finally { $source.Dispose() }
    }
}
