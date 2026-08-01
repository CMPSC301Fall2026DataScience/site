# Adding R Support to JupyterLite - Setup Complete ✅

## What Was Changed

### 1. Updated Requirements ([live/requirements.txt](live/requirements.txt))
Added JupyterLite core packages to support both Python and R kernels:
```
# JupyterLite core and kernels
jupyterlite-core
jupyterlite-pyodide-kernel
```

### 2. Modified Build Script ([RenderQuarto.sh](RenderQuarto.sh))
The build process now:
1. Renders the Quarto site
2. Installs JupyterLite dependencies
3. **NEW:** Clones and installs the WebR kernel for R support
4. Builds JupyterLite with both Python and R kernels

### 3. Created Sample R Notebook ([live/content/r_example.ipynb](live/content/r_example.ipynb))
A demonstration notebook showing:
- Basic R operations
- Working with vectors and statistics
- Creating data frames
- Simple plotting

### 4. Updated Documentation ([live/README.md](live/README.md))
Added information about the R kernel and how to use R packages.

## How to Build and Deploy

### First-Time Setup
```bash
# Make the build script executable (if not already)
chmod +x RenderQuarto.sh

# Run the build script
./RenderQuarto.sh
```

The script will:
- Install all Python dependencies
- Clone and install jupyterlite-webr-kernel
- Build the site with both Python and R support
- Output to `docs/` directory for GitHub Pages

### What to Expect
After building, the `jupyterlite-webr-kernel` directory will be created in your project root. This is normal and contains the R kernel source. You can add it to `.gitignore` if desired.

## Using R in JupyterLite

### Creating a New R Notebook
1. Navigate to your JupyterLite instance
2. Click "File" → "New" → "Notebook"
3. Select "R (WebR)" as the kernel
4. Start coding in R!

### Example R Code
```r
# Load data
data <- data.frame(
  x = 1:10,
  y = rnorm(10)
)

# Summary statistics
summary(data)

# Simple plot
plot(data$x, data$y)
```

### Installing R Packages
In an R notebook cell:
```r
install.packages("ggplot2")
library(ggplot2)
```

## Key Differences from Hugo Setup

The Hugo code you provided has been successfully adapted:

| Hugo Approach | Quarto Adaptation |
|--------------|-------------------|
| `hugo --minify --gc` | `quarto render` |
| `pip install -r requirements.txt` | `pip3 install -r live/requirements.txt` |
| `jupyter lite build --contents files --output-dir public/live` | `jupyter lite build --contents content --output-dir ../docs/live` |

The core WebR kernel installation is **identical** between both approaches.

## Testing Your Setup

1. **Build the site:**
   ```bash
   ./RenderQuarto.sh
   ```

2. **Open locally:**
   Open `docs/index.html` in your browser and navigate to JupyterLite

3. **Test Python:**
   - Open `welcome.ipynb` or create a new Python notebook
   - Run some Python code

4. **Test R:**
   - Open `r_example.ipynb` or create a new R notebook
   - Select "R (WebR)" kernel
   - Run some R code

## Troubleshooting

### Build Fails at WebR Installation
If the WebR kernel installation fails:
```bash
# Clean up and retry
rm -rf jupyterlite-webr-kernel
./RenderQuarto.sh
```

### R Kernel Not Showing Up
- Ensure the build completed without errors
- Check that `docs/live` contains the built JupyterLite environment
- Clear browser cache and reload

### Package Installation Issues
- **Python:** Some PyPI packages don't have WASM wheels
- **R:** Some CRAN packages may not be available in WebR yet
- Check package compatibility before installing

## Next Steps

1. ✅ Build your site with `./RenderQuarto.sh`
2. ✅ Test both Python and R kernels locally
3. ✅ Commit changes and push to GitHub
4. ✅ GitHub Pages will serve your updated site with dual-kernel support

## Additional Resources

- [JupyterLite Documentation](https://jupyterlite.readthedocs.io/)
- [WebR Project](https://docs.r-wasm.org/webr/latest/)
- [WebR Kernel for JupyterLite](https://github.com/r-wasm/jupyterlite-webr-kernel)

---

**You now have both Python and R programming environments running entirely in the browser!** 🎉
