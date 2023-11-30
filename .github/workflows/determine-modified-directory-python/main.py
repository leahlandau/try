import subprocess
import os
import sys

directory = os.getenv('INPUT_DIRECTORY')
try:
    result = subprocess.run(f'git diff --name-only HEAD~1 ${{ github.sha }} | grep -q \'^{directory}/\' && echo "true" || echo "false"',
                            shell=True, check=True, stdout=subprocess.PIPE, text=True)
    modified = result.stdout.strip()
    print(f'Directory {directory} has{" " if modified == "true" else " no"}changes')
    print(f'::set-output name=modified::{modified}')
except subprocess.CalledProcessError as e:
    print(f'Error determining modifications: {e}', file=sys.stderr)
    sys.exit(1)
