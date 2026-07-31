# Quick Start: Deploying R Support

## TL;DR - Just Push to GitHub!

Your GitHub Actions workflow has been updated to automatically build JupyterLite with R support. You don't need to install anything locally.

### What to Do Now:

```bash
# Commit all changes
git add .
git commit -m "Add R programming support with micromamba in GitHub Actions"
git push origin main
```

That's it! GitHub Actions will:
1. Install micromamba
2. Build the R kernel environment  
3. Build JupyterLite with both Python and R
4. Deploy to GitHub Pages

### Wait Time
The first build will take **10-15 minutes** because it needs to:
- Download and build the R WebAssembly environment
- Create the xeus-r kernel
- Build all the JupyterLite assets

Subsequent builds will be faster (3-5 minutes) due to caching.

### Check Build Status
1. Go to your GitHub repository
2. Click on the "Actions" tab
3. Watch the "Build and Deploy Quarto Site with JupyterLite" workflow
4. Wait for the green checkmark

### After Deployment
Visit your site and click the JupyterLite link. You should now see:
- **Python (Pyodide)** kernel - for Python programming
- **R (xeus-r)** kernel - for R programming

### Example R Notebooks Included
- `r_example.ipynb` - R basics
- `r_data_analysis.ipynb` - Data science with R

## If Build Fails
Check the Actions log for errors. Common issues:
- Environment file syntax errors
- Network issues downloading R packages
- Cache corruption (solution: clear Actions cache and rebuild)

## Local Development
If you want to test locally (optional):
1. Install micromamba: `brew install micromamba`
2. Run: `./build_jupyterlite.sh`
3. Run: `quarto render`
4. Test: `cd docs && python3 -m http.server 8000`

But remember: **you don't need to build locally** - GitHub Actions handles everything!

---

**Summary:** Just push to GitHub and let the automated build system handle the R kernel setup. No local micromamba installation needed!
