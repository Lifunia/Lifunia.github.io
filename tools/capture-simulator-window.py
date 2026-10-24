"""Read the CIQ simulator window without sending input; write a cropped PNG.

Used by the screenshot fixture. Requires only Python's standard library.
"""
import ctypes
from ctypes import wintypes
import struct
import sys
import zlib
from pathlib import Path

user = ctypes.WinDLL('user32', use_last_error=True)
gdi = ctypes.WinDLL('gdi32', use_last_error=True)
user.SetProcessDPIAware()
user.GetWindowDC.argtypes = [wintypes.HWND]
user.GetWindowDC.restype = wintypes.HDC
user.ReleaseDC.argtypes = [wintypes.HWND, wintypes.HDC]
user.PrintWindow.argtypes = [wintypes.HWND, wintypes.HDC, wintypes.UINT]
gdi.CreateCompatibleDC.argtypes = [wintypes.HDC]
gdi.CreateCompatibleDC.restype = wintypes.HDC
gdi.CreateCompatibleBitmap.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int]
gdi.CreateCompatibleBitmap.restype = wintypes.HBITMAP
gdi.SelectObject.argtypes = [wintypes.HDC, wintypes.HGDIOBJ]
gdi.SelectObject.restype = wintypes.HGDIOBJ
gdi.DeleteObject.argtypes = [wintypes.HGDIOBJ]
gdi.DeleteDC.argtypes = [wintypes.HDC]
gdi.GetDIBits.argtypes = [wintypes.HDC, wintypes.HBITMAP, wintypes.UINT,
                        wintypes.UINT, ctypes.c_void_p, ctypes.c_void_p, wintypes.UINT]


def capture(output, crop=None):
    windows = []

    @ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
    def visit(hwnd, _):
        title = ctypes.create_unicode_buffer(512)
        user.GetWindowTextW(hwnd, title, 512)
        if title.value.startswith('CIQ Simulator - Instinct'):
            windows.append(hwnd)
        return True

    user.EnumWindows(visit, 0)
    if len(windows) != 1:
        raise RuntimeError(f'Expected one Instinct simulator, found {len(windows)}')
    hwnd = windows[0]
    rect = wintypes.RECT()
    user.GetWindowRect(hwnd, ctypes.byref(rect))
    width, height = rect.right - rect.left, rect.bottom - rect.top
    source = user.GetWindowDC(hwnd)
    target = gdi.CreateCompatibleDC(source)
    bitmap = gdi.CreateCompatibleBitmap(source, width, height)
    previous = gdi.SelectObject(target, bitmap)
    try:
        if not user.PrintWindow(hwnd, target, 2):
            raise ctypes.WinError(ctypes.get_last_error())
        header = struct.pack('<IiiHHIIiiII', 40, width, -height, 1, 32, 0, 0, 0, 0, 0, 0)
        pixels = ctypes.create_string_buffer(width * height * 4)
        gdi.SelectObject(target, previous)
        if gdi.GetDIBits(target, bitmap, 0, height, pixels, header, 0) != height:
            raise RuntimeError('Could not read simulator pixels')
        raw = pixels.raw
        if len(set(raw)) < 8:
            raise RuntimeError('Simulator capture is blank; make its window visible before retrying')
        left, top, out_width, out_height = crop or (0, 0, width, height)
        if left < 0 or top < 0 or left + out_width > width or top + out_height > height:
            raise ValueError('Crop outside simulator window')
        rows = bytearray()
        for y in range(top, top + out_height):
            rows.append(0)
            for x in range(left, left + out_width):
                offset = (y * width + x) * 4
                rows.extend((raw[offset + 2], raw[offset + 1], raw[offset]))

        def chunk(kind, data):
            return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', zlib.crc32(kind + data))

        image = b'\x89PNG\r\n\x1a\n'
        image += chunk(b'IHDR', struct.pack('>IIBBBBB', out_width, out_height, 8, 2, 0, 0, 0))
        image += chunk(b'IDAT', zlib.compress(rows)) + chunk(b'IEND', b'')
        Path(output).write_bytes(image)
    finally:
        gdi.DeleteObject(bitmap)
        gdi.DeleteDC(target)
        user.ReleaseDC(hwnd, source)


if __name__ == '__main__':
    capture(sys.argv[1], tuple(map(int, sys.argv[2:])) or None)
