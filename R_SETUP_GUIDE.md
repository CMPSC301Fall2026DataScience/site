# Adding R Support to JupyterLite - Setup Guide

## What Was Done

Your Quarto project now supports **both Python and R** programming in JupyterLite! Here's what was added:

### 1. Updated Build Script
- Modified [build_jupyterlite.sh](build_jupyterlite.sh) to install `jupyterlite-xeus` package
- This package provides the xeus-r kernel for R programming in the browser

### 2. Created Example R Notebooks
Two example notebooks were added to demonstrate R capabilities:

- **[r_example.ipynb](content/r_example.ipynb)** - Introduction to R basics
  - Variables and arithmetic
  - Vectors and data structures
  - Data frames
  - Statistical analysis
  - Custom functions
  - Basic plotting

- **[r_data_analysis.ipynb](content/r_data_analysis.ipynb)** - Data science with R
  - Creating datasets
  - Summary statistics
  - Correlation analysis
  - Linear regression
  - Making predictions
  - Data visualization
  - Grouped analysis

### 3. Updated Documentation
- Updated [README.md](README.md) with R kernel information
- Added usage instructions for R programming
- Documented available kernels

## How to Build and Deploy

### Step 1: Install Required Packages

Run the build script which will automatically install dependencies:

```bash
cd /Users/obonhamcarter/Desktop/src/3_web/classes/Cs301F2026/site_301F2026
./build_jupyterlite.sh
```

Or manually install:

```bash
pip install jupyterlite-core jupyterlite-pyodide-kernel jupyterlite-xeus
```

### Step 2: Build JupyterLite

The build script handles this automatically, but you can also run:

```bash
python3 -m jupyterlite_core.app build --contents live/content --output-dir docs/live
```

### Step 3: Render Quarto Site

Build the complete Quarto site:

```bash
quarto render
```

Or use your render script:

```bash
./RenderQuarto.sh
```

### Step 4: Test Locally

Test the site locally before deploying:

```bash
cd docs
python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser and click on the JupyterLite link.

### Step 5: Deploy to GitHub Pages

Commit and push your changes:

```bash
git add .
git commit -m "Add R programming support to JupyterLite"
git push origin main
```

GitHub Pages will automatically deploy the updated site.

## Using R in JupyterLite

### For Instructors:
1. Navigate to the JupyterLite environment
2. Create new R notebooks in `live/content/` for course materials
3. Students can open and interact with these notebooks

### For Students:
1. Click the **JupyterLite** link in the navigation menu
2. Wait for the environment to load (30-60 seconds on first load)
3. Choose from existing notebooks:
   - **welcome.ipynb** - Python introduction
   - **r_example.ipynb** - R programming basics
   - **r_data_analysis.ipynb** - R data science
4. Or create a new notebook:
   - File → New → Notebook
   - Select **R (xeus-r)** kernel for R programming
   - Select **Python (Pyodide)** for Python programming

## Available Kernels

### Python (Pyodide)
- Full Python 3.11+ in the browser
- Data science libraries: pandas, numpy, matplotlib, seaborn, plotly, scikit-learn
- Install additional packages: `await micropip.install('package-name')`

### R (xeus-r)
- Core R functionality
- Base R packages
- Statistical computing
- Data visualization
- **Note:** Advanced CRAN packages may not be available in browser

## Important Notes

### Browser Compatibility
- **Recommended:** Chrome, Firefox, or Edge (latest versions)
- **Not recommended:** Safari (may have WebAssembly issues)

### Performance
- R and Python run in WebAssembly (slower than native)
- Large datasets may be slow
- Good for learning and small-to-medium analyses

### Data Persistence
- All work is saved in **browser local storage**
- Students should download important notebooks
- Clearing browser data will delete notebooks

### Limitations
- Not all Python/R packages available
- Cannot install system-level dependencies
- Memory limitations based on browser

## Troubleshooting

### Build Issues
```bash
# Clear previous build
rm -rf docs/live/*

# Reinstall packages
pip install --upgrade jupyterlite-core jupyterlite-pyodide-kernel jupyterlite-xeus

# Rebuild
./build_jupyterlite.sh
```

### R Kernel Not Appearing
1. Ensure `jupyterlite-xeus` is installed
2. Rebuild JupyterLite
3. Clear browser cache
4. Try a different browser

### Notebooks Not Loading
1. Check browser console for errors
2. Verify files are in `docs/live/` after build
3. Ensure GitHub Pages is properly configured

## Next Steps

1. **Create more R examples** - Add domain-specific R notebooks for your course
2. **Customize welcome screen** - Edit `live/content/welcome.ipynb`
3. **Add course materials** - Create notebooks for lectures and assignments
4. **Test thoroughly** - Have students test in different browsers
5. **Document limitations** - Let students know what packages are available

## Additional Resources

- [JupyterLite Documentation](https://jupyterlite.readthedocs.io/)
- [xeus-r Kernel](https://github.com/jupyter-xeus/xeus-r)
- [Quarto Documentation](https://quarto.org/)

## Support

If you encounter issues:
1. Check the browser console for errors
2. Review the JupyterLite build logs
3. Test in multiple browsers
4. Check that all dependencies are installed

---

**Summary:** Your Quarto project now supports both Python and R in JupyterLite! Students can write, run, and share code in both languages directly in their browsers without any installations.
