# Sauna Timer screenshot sources

- Captured on 2026-10-03 from Sauna Timer 0.6.1 (`Sauna-Timer/bin/SaunaTimer.prg`).
- Device: Garmin Connect IQ Simulator, Instinct 2 / Solar / Dual Power / dezl Edition.
- Captures contain the simulator's watch panel only, at 382 x 505 pixels.
- Heart rate, scores, dates and times are screenshot sample data. FIT Save remained OFF.
- Heart-rate examples were recaptured with a temporary copy of the app that replaces only the sensor data in `refreshHeartRate()`: Sauna 100–135, WB 75–100, Rest 62–85 bpm, cycling once per second. Scores and history averages are calculated by the unchanged app code from these samples. The fixture uses a separate application ID to isolate its history. Production watch sources were not edited.
- These PNGs are unannotated originals. `tools/annotate-sauna-screens.ps1` draws explanatory outlines and writes the corresponding PNGs to `assets/images/`.
- `Buttons.png` uses the unannotated `TOP.png` capture with colored circles identifying ENTER (red), BACK (blue), UP (purple), and DOWN (orange).
- `SettingFIT.png` shows FIT Save selected before starting a session. The settings and main menus cycle the selected item to the first row.
- The existing `hisotry2.png` filename is preserved to keep asset links compatible.

Regenerate the annotated images from the repository root:

```powershell
./tools/annotate-sauna-screens.ps1
```
