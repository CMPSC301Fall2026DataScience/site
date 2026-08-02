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

# Step 2: Install JupyterLite dependencies
echo ""
echo "📦 Step 2: Installing JupyterLite dependencies..."

# Install JupyterLite with pinned versions to avoid compatibility issues
pip3 install jupyter
# pip3 install "jupyterlite-core>=0.4.0,<0.5.0" "jupyterlite-pyodide-kernel>=0.4.0,<0.5.0"
pip3 install "jupyterlite-core jupyterlite-pyodide-kernel

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install JupyterLite core packages"
    exit 1
fi

# Install data science packages from requirements.txt
pip3 install -r live/requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install requirements"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Step 3: Install WebR kernel for R support
echo ""
echo "🔬 Step 3: Installing WebR kernel for R support..."

# Install jupyterlite-webr from PyPI
pip3 install jupyterlite-webr

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install WebR kernel"
    exit 1
fi

echo "✅ WebR kernel installed successfully"

# Step 4: Build JupyterLite with Python and R kernels
echo ""
echo "🚀 Step 4: Building JupyterLite environment (Python + R)..."

# Remove any stale jupyter-lite.json from docs to prevent path conflicts
if [ -f "docs/jupyter-lite.json" ]; then
    echo "   Cleaning up stale config file: docs/jupyter-lite.json"
    rm -f docs/jupyter-lite.json
fi

# Build from project root (matching GitHub Actions workflow)
#jupyter lite build --contents live/content --output-dir docs/live
# jupyter lite build

if [ $? -ne 0 ]; then
    echo "❌ Error: JupyterLite build failed"
    exit 1
fi

echo "✅ JupyterLite built successfully with Python and R support"

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
