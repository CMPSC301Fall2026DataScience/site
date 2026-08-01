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

# Install JupyterLite and dependencies from requirements.txt
pip3 install -r live/requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install requirements"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Step 3: Install WebR kernel for R support
echo ""
echo "🔬 Step 3: Installing WebR kernel for R support..."

# Clone and install jupyterlite-webr-kernel
if [ ! -d "jupyterlite-webr-kernel" ]; then
    git clone https://github.com/r-wasm/jupyterlite-webr-kernel
fi

cd jupyterlite-webr-kernel
pip3 install .

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to install WebR kernel"
    cd ..
    exit 1
fi

cd ..
echo "✅ WebR kernel installed successfully"

# Step 4: Build JupyterLite with Python and R kernels
echo ""
echo "🚀 Step 4: Building JupyterLite environment (Python + R)..."

cd live
jupyter lite build --contents content --output-dir ../docs/live

if [ $? -ne 0 ]; then
    echo "❌ Error: JupyterLite build failed"
    cd ..
    exit 1
fi

cd ..
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
