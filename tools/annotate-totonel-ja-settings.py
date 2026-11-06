"""Regenerate the Japanese Settings annotation from its retained screenshot."""
import importlib.util
import sys
from pathlib import Path

# Regenerating assets should not leave Python cache files in the site checkout.
sys.dont_write_bytecode = True
TOOLS = Path(__file__).resolve().parent


def main():
    # Share SVG generation, but keep Japanese label and button bounds separate.
    spec = importlib.util.spec_from_file_location(
        'totonel_annotations', TOOLS / 'annotate-totonel-en-screens.py'
    )
    generator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(generator)
    generator.IMAGE_DIRECTORY = TOOLS.parent / 'assets/images/totonel/ja'
    generator.SCREENS = {
        'totonel-settings': ((0, 60, 1080, 1700), [
            ('cyan', 18, 190, 1044, 210),
            ('blue', 26, 460, 1028, 282),
            ('orange', 26, 864, 1028, 170),
            ('green', 26, 1068, 1028, 126),
            ('pink', 26, 1224, 1028, 126),
            ('purple', 26, 1562, 570, 118),
        ]),
    }
    generator.main()


if __name__ == '__main__':
    main()
