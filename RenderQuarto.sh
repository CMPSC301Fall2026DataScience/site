#!/bin/bash
#
# RenderQuarto.sh -- build the CMPSC 301 site locally.
#
# Mirrors .github/workflows/deploy.yml exactly:
#   1. quarto render          -> docs/
#   2. jupyter lite build     -> docs/live/
#
# Preview afterwards with:  python3 -m http.server -d docs 8000
# (open http://localhost:8000/live/ -- file:// will NOT work, the
#  service worker and WASM kernels require a real HTTP origin)

set -euo pipefail

cd "$(dirname "$0")"

echo "📝 Rendering Quarto site to docs/ ..."
quarto render

echo "📦 Installing JupyterLite build requirements ..."
python3 -m pip install -r live/requirements.txt

echo "🚀 Building JupyterLite (Python + R) into docs/live ..."
cd live
jupyter lite build --output-dir ../docs/live
cd ..

echo ""
echo "✅ Done. Preview with:"
echo "     python3 -m http.server -d docs 8000"
echo "     open http://localhost:8000/live/"
