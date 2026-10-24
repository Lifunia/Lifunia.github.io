"""Capture the simulator watch panel after each fixture frame renders."""
from pathlib import Path
import subprocess
import sys
import time
sys.dont_write_bytecode = True
from capture_window import capture

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
        time.sleep(0.4)
        capture(output / (name + '.png'))
        count += 1
code = process.wait()
if code or count != 18:
    raise RuntimeError(f'Simulator capture failed: exit={code}, frames={count}/18')
print(f'Captured {count} simulator frames.')
