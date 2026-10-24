"""Capture each fixture frame after the SDK reports that it has rendered."""
import importlib.util
from pathlib import Path
import subprocess
import sys
import time

sys.dont_write_bytecode = True

helper_path = Path(__file__).resolve().parents[1] / 'capture-simulator-window.py'
spec = importlib.util.spec_from_file_location('capture_window', helper_path)
helper = importlib.util.module_from_spec(spec)
spec.loader.exec_module(helper)
output = Path(sys.argv[1])
output.mkdir(parents=True, exist_ok=True)
process = subprocess.Popen(sys.argv[2:], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
count = 0
for line in process.stdout:
    print(line.rstrip(), flush=True)
    if line.startswith('CAPTURE_READY '):
        name = line.strip().split(' ', 1)[1]
        if not name.replace('_', '').isalnum():
            raise ValueError('Invalid fixture frame name')
        time.sleep(0.35)
        helper.capture(output / (name + '.png'), (8, 52, 382, 505))
        count += 1
code = process.wait()
if code or count != 5:
    raise RuntimeError(f'Simulator capture failed: exit={code}, frames={count}/5')
print(f'Captured {count} simulator frames.')
