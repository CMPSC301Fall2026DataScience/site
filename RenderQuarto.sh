#!/bin/bash

# RenderQuarto.sh
# Build script for the CMPSC 301 Data Science website

echo "🚀 Building CMPSC 301 Data Science Website"
echo "=========================================="

# Step 1: Render Quarto site
echo ""
echo "📝 Step 1: Rendering Quarto site..."
quarto render

if [ $? -ne 0 ]; then
    echo "❌ Error: Quarto render failed"
    exit 1
fi

echo "✅ Quarto site rendered successfully"

# Step 2: Build JupyterLite
echo ""
echo "🔬 Step 2: Building JupyterLite environment..."

# Check if jupyterlite is installed
if ! command -v jupyter &> /dev/null; then
    echo "⚠️  Warning: Jupyter not found. Skipping JupyterLite build."
    echo "   Install with: pip install jupyterlite-core jupyterlite-pyodide-kernel"
    pip3 install jupyterlite-core jupyterlite-pyodide-kernel
else
    cd live
    jupyter lite build --output-dir ../docs/live --base-url /site/live/
    
    if [ $? -ne 0 ]; then
        echo "❌ Error: JupyterLite build failed"
        cd ..
        exit 1
    fi
    
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
    
    echo "✅ JupyterLite built successfully"
fi

# Step 3: Report completion
echo ""
echo "=========================================="
echo "✨ Build completed successfully!"
echo ""
echo "📂 Output directory: docs/"
echo "🌐 Open docs/index.html in your browser to preview"
echo ""
echo "🚀 To deploy to GitHub Pages:"
echo "   1. Commit and push changes"
echo "   2. Enable GitHub Pages in repository settings"
echo "   3. Select 'GitHub Actions' as source"
echo ""
