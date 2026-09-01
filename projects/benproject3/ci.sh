#!/usr/bin/env bash
# The single entry point CI uses to test this project. Change what happens here
# and you change how the project is tested — the pipeline itself never changes.
set -euo pipefail

echo "== CI for $(basename "$PWD") =="
python -m pip install --quiet --upgrade pip
if [ -f requirements.txt ]; then
  python -m pip install --quiet -r requirements.txt
fi
python -m pytest -q
