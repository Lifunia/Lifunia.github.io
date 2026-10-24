# Sauna Timer screenshot sources

- History captures (`History`, `history1`, `HistoryScore`, `HistorySetDetail`, `HistoryNoDetails`), set completion (`Result_set`), per-set Result (`Result`) were captured on 2026-10-19 from the unmodified Sauna Timer 0.6.2 product rendering classes.
- Other captures, including Setting and the unchanged overall score page (`Result_all`), remain from Sauna Timer 0.6.1, captured on 2026-10-03 (`Sauna-Timer/bin/SaunaTimer.prg`).
- Device: Garmin Connect IQ Simulator, Instinct 2 / Solar / Dual Power / dezl Edition.
- Captures contain the simulator's watch panel only, at 382 x 505 pixels.
- Heart rate, scores, dates and times are screenshot sample data. FIT Save remained OFF.
- For the 0.6.1 captures, heart-rate examples were recaptured with a temporary copy of the app that replaces only the sensor data in `refreshHeartRate()`: Sauna 100–135, WB 75–100, Rest 62–85 bpm, cycling once per second. Scores and history averages are calculated by the unchanged app code from these samples. The fixture uses a separate application ID to isolate its history. Production watch sources were not edited.
- These PNGs are unannotated originals. `tools/annotate-sauna-screens.ps1` draws explanatory outlines and writes the corresponding PNGs to `assets/images/`.
- `Buttons.png` uses the unannotated `TOP.png` capture with colored circles identifying ENTER (red), BACK (blue), UP (purple), and DOWN (orange).
- `SettingFIT.png` shows FIT Save OFF, the default setting. FIT Save remains available in 0.6.2; users can enable it before starting a session. The settings and main menus cycle the selected item to the first row.
- The old `hisotry2.png` is retained for compatibility; the current History guide uses the combined summary and new set detail screens.
- The 0.6.2 screenshot fixture uses a separate application ID. Scores and heart rates are explicit sample values, not measured data. Phase maximum/minimum averages are calculated by the product code from those saved samples. The `No details` frame uses a summary-only entry and the actual ENTER handler.
- The 2026-10-19 images were captured through the Computer Use screenshot API, cropped to the watch panel at (1, 78, 576, 759) in the 578px-wide simulator window, and resized to 382 x 505. Screens advanced automatically in the screenshot fixture. Earlier captures used a crop of (8, 52, 382, 505).

Regenerate the annotated images from the repository root:

```powershell
./tools/annotate-sauna-screens.ps1
```

Recapture only the five History screens from the current app sources, then regenerate their annotations:

```powershell
./tools/capture-sauna-screens.ps1 -AppRoot D:/develop/Sauna-Timer
./tools/annotate-sauna-screens.ps1 -HistoryOnly
```

Requires the configured Connect IQ SDK, Java, Python 3, and an already open Instinct 2 simulator. The app's developer key is used only for the local fixture build. Build output goes to the system temporary folder.

## v0.7.1 representative device screenshots

- `fr965/` and `fenix7/` contain the unannotated simulator originals captured on 2026-10-21 for Forerunner 965 and fēnix 7.
- These two raw directories are local working files excluded by `.gitignore`. On a fresh checkout, run the capture commands below before preparing the annotated images. The prepared images in `assets/images/sauna-timer/fr965/` and `fenix7/` are tracked in Git.
- Source: Sauna-Timer main commit `e1df2cd`, with `APP_VERSION = "0.7.1"`. The product source files and rendering classes were not changed.
- `tools/sauna-device-screens/DeviceScreens.mc` supplies explicit sample heart rates, scores, dates, and timer states to the product views. It uses a separate application ID and sets FIT Save OFF; the normal app's storage is not modified.
- The 18 captures cover the same screen types as the Instinct guide. `Buttons.png` uses the original TOP capture with colored circles marking the buttons. No Run History screenshot is added.
- `tools/prepare-sauna-device-screens.ps1` crops the simulator chrome, resizes the watch panel to 382px wide while preserving its aspect ratio, and draws explanatory outlines using `tools/sauna-device-screens/annotations.json`. Output goes to `assets/images/sauna-timer/fr965/` and `fenix7/`. Coordinates in the JSON are final-image pixels; each frame lists its color, x, y, width, height, and optionally `ellipse`. Originals in this raw directory are never modified.
- The colors match the Instinct guide: red for heart rate, scores or the selected item; blue for the phase, date/time, set title or detail hint; green for timer values and heart-rate tables; yellow for the clock, page/item counts or button hints; lime for set/session numbers. Button circles use red (ENTER), blue (BACK), purple (UP), and orange (DOWN). Japanese and English pages use the same images and matching colored labels.
- Capture uses the existing SDK and Python's standard library. The simulator is shown without activation so PrintWindow can read its window. Keep the simulator on one device until capture finishes; do not run the two commands concurrently.

From the repository root, capture each device sequentially, then prepare the page images:

```powershell
./tools/capture-sauna-device-screens.ps1 -AppRoot D:/develop/Sauna-Timer -Device fr965
./tools/capture-sauna-device-screens.ps1 -AppRoot D:/develop/Sauna-Timer -Device fenix7
./tools/prepare-sauna-device-screens.ps1
```
