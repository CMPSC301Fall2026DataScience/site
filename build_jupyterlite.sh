#!/bin/bash
# Build JupyterLite for CMPSC 301 Course Website

echo "🚀 Building JupyterLite..."
echo "================================"

# Check if jupyterlite is installed
if ! python3 -c "import jupyterlite_core" 2>/dev/null; then
    echo "❌ JupyterLite not found. Installing..."
    python3 -m pip install jupyterlite-core jupyterlite-pyodide-kernel
    echo "✅ JupyterLite installed"
fi

# Check if WebR kernel is installed
if ! python3 -c "import jupyterlite_webr_kernel" 2>/dev/null; then
    echo "❌ WebR kernel not found. Installing..."
    if [ ! -d "jupyterlite-webr-kernel" ]; then
        git clone https://github.com/r-wasm/jupyterlite-webr-kernel
    fi
    cd jupyterlite-webr-kernel
    python3 -m pip install .
    cd ..
    echo "✅ WebR kernel installed"
fi

# Clean previous build
echo ""
echo "🧹 Cleaning previous build..."
rm -rf docs/live/*
echo "✅ Clean complete"

# Build JupyterLite
echo ""
echo "🔨 Building JupyterLite with Python and WebR kernels..."
cd live
jupyter lite build --output-dir ../docs/live --base-url /site/live/
cd ..

# Fix baseUrl for GitHub Pages subdirectory deployment
echo ""
echo "🔧 Fixing baseUrl for GitHub Pages deployment..."
python3 << 'PYTHON_SCRIPT'
import json

config_path = 'docs/live/jupyter-lite.json'
with open(config_path, 'r') as f:
    config = json.load(f)

config['jupyter-config-data']['baseUrl'] = '/site/live/'

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ baseUrl updated to '/site/live/'")
PYTHON_SCRIPT

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "📂 Output directory: docs/live"
    echo "🌐 To test locally, run:"
    echo "   cd docs/live && python3 -m http.server 8000"
    echo "   Then open: http://localhost:8000"
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
