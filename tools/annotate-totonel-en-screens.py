"""Annotate English Totonel captures without changing the app pixels.

Run from any directory: python tools/annotate-totonel-en-screens.py
Coordinates refer to the unmodified 1080 x 2400 source PNGs.
"""
import base64
from pathlib import Path

IMAGE_DIRECTORY = Path(__file__).resolve().parents[1] / 'assets/images/totonel/en'
COLORS = {'red': '#ff1726', 'blue': '#4645df', 'cyan': '#00a9ce',
          'green': '#1bb84c', 'orange': '#ff8426', 'purple': '#ab47bc', 'pink': '#ed74a8'}
# View boxes exclude OS bars or unrelated scroll content; the PNGs stay intact.
SCREENS = {
 'totonel-list': ((0, 60, 1080, 1300), [
  ('red', 876, 60, 102, 102), ('blue', 978, 60, 102, 102),
  ('purple', 12, 178, 1056, 120), ('green', 10, 310, 1060, 164)]),
 'totonel-calendar': ((0, 60, 1080, 1770), [
  ('red', 179, 1068, 135, 168), ('blue', 12, 1508, 1056, 296)]),
 'totonel-detail': ((0, 60, 1080, 1800), [
  ('red', 250, 180, 580, 120), ('blue', 156, 880, 335, 115),
  ('cyan', 510, 880, 430, 115), ('green', 734, 360, 89, 97),
  ('orange', 815, 360, 88, 97), ('purple', 908, 360, 89, 97),
  ('purple', 908, 1080, 89, 97), ('pink', 60, 1565, 930, 255)]),
 'totonel-set-delete': ((0, 60, 1080, 1800), [
  ('red', 150, 1060, 780, 315), ('blue', 740, 1439, 208, 118)]),
 'totonel_edit': ((180, 900, 720, 600), [
  ('red', 240, 1048, 555, 136), ('blue', 240, 1190, 600, 139)]),
 'totonel-analysis': ((0, 60, 1080, 1860), [
  ('red', 48, 528, 690, 110), ('blue', 48, 634, 645, 117),
  ('green', 913, 360, 114, 114), ('green', 904, 1409, 114, 114)]),
 'totonel-set-details': ((0, 414, 1080, 1920), []),
 'totonel-settings': ((0, 60, 1080, 1700), [
  ('cyan', 18, 190, 1044, 210), ('blue', 26, 460, 1028, 277),
  ('orange', 26, 860, 1028, 170), ('green', 26, 1064, 1028, 126),
  ('pink', 26, 1220, 1028, 126), ('purple', 26, 1558, 432, 118)]),
 'totonel-settings-lower': ((0, 980, 1080, 1280), [
  ('red', 34, 1070, 1012, 90), ('blue', 18, 1178, 1044, 208),
  ('orange', 26, 1485, 1028, 135), ('purple', 26, 1689, 801, 118),
  ('green', 26, 2039, 359, 118)]),
}


def main():
    for name, (view_box, frames) in SCREENS.items():
        encoded = base64.b64encode((IMAGE_DIRECTORY / (name + '.png')).read_bytes()).decode('ascii')
        x, y, width, height = view_box
        lines = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="{x} {y} {width} {height}">',
                 '<!-- English app capture; annotations and cropping only. -->',
                 f'<image width="1080" height="2400" href="data:image/png;base64,{encoded}"/>',
                 '<g fill="none" stroke-width="5">']
        for color, left, top, frame_width, frame_height in frames:
            lines.append(f'<rect x="{left}" y="{top}" width="{frame_width}" height="{frame_height}" stroke="{COLORS[color]}"/>')
        lines.extend(['</g>', '</svg>'])
        (IMAGE_DIRECTORY / (name + '.svg')).write_text('\n'.join(lines) + '\n', encoding='utf-8')
        print('Annotated', name)


if __name__ == '__main__':
    main()
