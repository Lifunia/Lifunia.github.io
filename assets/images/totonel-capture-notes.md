# ととねるの紹介用キャプチャ

2026年10月6日、Androidエミュレータ上のととねる0.1.2で撮影。

- `totonel-detail.png`: セッション詳細（概要）。下部の「セット削除」ボタンを含む。
- `totonel-set-delete.png`: 「セット削除」を押し、Set1とSet3を選択した状態。削除は実行せず、撮影後にキャンセルした。

対象はアプリ側の `tool/seed_intro_demo_data.py` に定義された架空のセッション `demo-20260921-01`（七色ロウリュ、2026年9月21日15:15）。記録・施設・評価・スコア・心拍は紹介用のダミーデータ。

PNGは1080×2400の未加工キャプチャ。`tools/annotate-totonel-screens.ps1` はPNGを埋め込んだSVGを生成する。SVGではOSのバーを表示範囲から外し、操作説明に対応する枠を重ねる。アプリ画面の内容は変更しない。


## English screen guide: Totonel 0.1.4

- Captured on 2026-11-06 from mobile commit `7ebd5ae`, version `0.1.4+4`, using a profile build so no debug banner appears. Product sources were not modified for the capture.
- Device: isolated Medium Phone API 35 Android emulator, 1080 x 2400 pixels, display density 340. The app language is English. System bars and unrelated scroll content are excluded only by SVG view boxes.
- Source PNGs and annotated SVGs are in `totonel/en/`. Japanese screenshots and their annotation script remain unchanged.
- The six fictional sessions come from the mobile repository's `tool/seed_intro_demo_data.py`. The same invented dates, ratings, scores, and heart rates are retained; fictional display names are Moonview Sauna, Harbor Sauna, Woodland Sauna, Sky Terrace, Evening Sauna, and Rainbow Sauna.
- The detail, editor, analysis, and set-deletion captures show `demo-20260921-01`, Rainbow Sauna. Set1 and Set3 were selected in the deletion dialog, then canceled; no sets were deleted.
- Automatic sync is OFF. Settings uses the deliberately invalid sample key `demo-not-a-real-api-key`, displayed by the app as `********`. No connection test, manual sync, or external service request was made.
- The Settings screenshots show Hide scores before rating ON, Original data as the default heart rate view, and Standard score as the default score view.
- Regenerate every English annotation with `python tools/annotate-totonel-en-screens.py`. The script reads the retained PNGs and changes only SVG crops and explanatory frames.
- Background for the English definition of Totonoi: [PLOS ONE study describing physical and mental relaxation and clarity](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0294137). The page distinguishes this subjective experience from the app's own standard Score and personal Rating; it makes no claim that a score measures that state.


## Japanese Settings with language selection: Totonel 0.1.4

- Captured on 2026-11-06 from the same unmodified `0.1.4+4` profile build and isolated emulator used for the English screen guide (1080 x 2400 pixels, display density 340).
- The app is set to 日本語. Home view is List, Hide scores before rating is ON, and default heart rate/score are Original data and Standard score. Automatic sync remains OFF; only the deliberately invalid local sample API key is saved.
- `totonel/ja/totonel-settings.png` is the unmodified capture. Its SVG excludes the system bars and content below the backup area, and adds matching guide frames. The previous Japanese Settings PNG and SVG remain available at their original paths.
- Regenerate with `python tools/annotate-totonel-ja-settings.py`. This uses the shared SVG writer while retaining Japanese-specific frame coordinates, including the wider export/import buttons.
