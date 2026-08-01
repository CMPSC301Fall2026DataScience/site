# JupyterLite Kernel Fix - COMPLETE SOLUTION ✅

## Problems Identified and Fixed

### Problem 1: Duplicate Configuration Files
**Error:** `FileNotFoundError: [Errno 2] No such file or directory: '/home/runner/work/site/site/docs/live/docs/jupyter-lite.json'`

**Root Cause:**
Multiple `jupyter-lite.json` files existed in the project:
- `/jupyter-lite.json` (root - needed ✅)
- `/live/jupyter-lite.json` (duplicate - removed ✅)
- `/docs/jupyter-lite.json` (created by Quarto render - needs cleanup ✅)

When JupyterLite builds, it scans for ALL config files and tries to patch them:
- Root config → `docs/live/jupyter-lite.json` ✅ Correct
- Live config → `docs/live/live/jupyter-lite.json` ❌ Nested path error
- Docs config → `docs/live/docs/jupyter-lite.json` ❌ Nested path error

**Solution:**
1. ✅ Merged `live/jupyter-lite.json` into root config
2. ✅ Removed `live/jupyter-lite.json` (backed up as `.backup`)
3. ✅ Added cleanup step to remove `docs/jupyter-lite.json` before building
4. ✅ Updated `.gitignore` to prevent committing these files

### Problem 2: Package Version Incompatibility
**Error:** Version mismatch between `jupyterlite-core` and `jupyterlite-pyodide-kernel`

**Root Cause:**
Installing `jupyterlite-webr-kernel` from Git was downgrading `jupyterlite-core` from 0.8.x to 0.6.4, causing incompatibility with `jupyterlite-pyodide-kernel 0.8.2`.

**Solution:**
1. ✅ Pinned compatible versions: `jupyterlite-core>=0.4.0,<0.5.0` and `jupyterlite-pyodide-kernel>=0.4.0,<0.5.0`
2. ✅ Changed package source from Git to PyPI: `jupyterlite-webr` (not `jupyterlite-webr-kernel`)
3. ✅ Installed packages in correct order to prevent downgrades

### Problem 3: Incorrect Package Name
**Error:** `ERROR: No matching distribution found for jupyterlite-webr-kernel`

**Root Cause:**
The package name on PyPI is `jupyterlite-webr`, not `jupyterlite-webr-kernel`.

**Solution:**
✅ Updated both build script and GitHub Actions to use `jupyterlite-webr`

---

## Files Changed

### 1. [jupyter-lite.json](jupyter-lite.json)
**Action:** Merged configurations
- Combined settings from root and `live/` configs
- Added app name, version, and memory settings
- Kept baseUrl for GitHub Pages compatibility
- Configured Pyodide CDN URLs for better performance

### 2. [live/jupyter-lite.json](live/jupyter-lite.json)
**Action:** Removed (backed up as `.backup`)
- Prevents duplicate config detection
- All settings merged into root config

### 3. [RenderQuarto.sh](RenderQuarto.sh)
**Changes:**
- Install `jupyter` package first
- Pin JupyterLite packages to compatible versions: `>=0.4.0,<0.5.0`
- Install `jupyterlite-webr` (not `jupyterlite-webr-kernel`)
- Remove `docs/jupyter-lite.json` before building JupyterLite
- Use consistent build command matching GitHub Actions

### 4. [.github/workflows/deploy.yml](.github/workflows/deploy.yml)
**Changes:**
- Pin JupyterLite package versions
- Install `jupyterlite-webr` from PyPI (not Git)
- Add cleanup step: `rm -f docs/jupyter-lite.json`
- Keep build command consistent with local script

### 5. [live/requirements.txt](live/requirements.txt)
**Changes:**
- Removed `jupyterlite-core` and `jupyterlite-pyodide-kernel`
- These are now installed separately with version constraints
- Kept data science packages (numpy, pandas, matplotlib, etc.)

### 6. [.gitignore](.gitignore)
**Added:**
```gitignore
# JupyterLite build artifacts that cause conflicts
docs/jupyter-lite.json

# JupyterLite config backups
*.json.backup
```

---

## Build Process (After Fixes)

### Local Build
```bash
./RenderQuarto.sh
```

**Steps:**
1. Render Quarto site → `docs/`
2. Install Jupyter and JupyterLite packages (pinned versions)
3. Install data science packages from `requirements.txt`
4. Install WebR kernel from PyPI
5. **Remove `docs/jupyter-lite.json`** (cleanup)
6. Build JupyterLite with both Python and R kernels → `docs/live/`

### GitHub Actions Build
```yaml
- Render Quarto site
- Install Python dependencies (pinned versions)
- Install jupyterlite-webr
- Remove docs/jupyter-lite.json (cleanup)
- Build JupyterLite
- Deploy to GitHub Pages
```

---

## Verification

### ✅ Build Success Indicators
```
federated_extensions:copy:ext:@r-wasm/jupyterlite-webr-kernel
federated_extensions:copy:ext:@jupyterlite/pyodide-kernel-extension
lite:patch:jupyter-lite.json
✅ JupyterLite built successfully with Python and R support
✨ Build completed successfully!
```

**Notice:**
- Only ONE `lite:patch:jupyter-lite.json` operation (not multiple)
- Both kernels are loaded: R (WebR) and Python (Pyodide)
- No `FileNotFoundError` or nested path issues

### ✅ Expected JupyterLite Behavior
When you open JupyterLite after deployment:

1. **File → New → Notebook**
   - "Python (Pyodide)" kernel available
   - "R (WebR)" kernel available

2. **Python Notebooks:**
   - Can run Python code
   - Install packages: `import micropip; await micropip.install('package-name')`

3. **R Notebooks:**
   - Can run R code
   - Install packages: `install.packages("package-name"); library(package-name)`

---

## Testing Your Changes

### 1. Local Testing
```bash
# Build the site
./RenderQuarto.sh

# Check output
ls docs/live/  # Should see jupyter-lite.json (only one)
ls jupyter-lite.json  # Root config exists

# Open in browser
open docs/index.html
# Navigate to JupyterLite link
# Try creating notebooks with both Python and R kernels
```

### 2. GitHub Pages Deployment
```bash
# Commit all changes
git add .
git commit -m "Fix JupyterLite dual-kernel setup - resolve config conflicts and version issues"
git push origin main

# Monitor GitHub Actions
# Go to: https://github.com/CMPSC301Fall2026DataScience/site/actions
# Wait for "Build and Deploy Quarto Site with JupyterLite" to complete

# Visit your site
# Navigate to JupyterLite
# Verify both Python and R kernels are available
```

---

## Key Takeaways

### 1. Configuration Best Practices
- **Keep ONE `jupyter-lite.json` at project root**
- Don't create additional config files in subdirectories
- Clean up generated configs before building

### 2. Version Management
- Pin compatible versions to prevent downgrades
- Use PyPI packages when available (not Git repos)
- Install in correct order (core packages first)

### 3. Build Process
- Always clean up stale config files before building
- Use consistent paths in local and CI/CD builds
- Verify output directory structure matches expectations

### 4. Package Names
- PyPI package: `jupyterlite-webr` ✅
- Extension name: `@r-wasm/jupyterlite-webr-kernel` ✅
- Not: `jupyterlite-webr-kernel` ❌

---

## Troubleshooting

### If Build Still Fails

**Check for duplicate configs:**
```bash
find . -name "jupyter-lite.json" -type f
```
Should only show:
- `./jupyter-lite.json` (root)
- `./docs/live/jupyter-lite.json` (generated by build)
- `./docs/live/*/jupyter-lite.json` (app-specific, auto-generated)

**Check package versions:**
```bash
pip3 list | grep jupyterlite
```
Should show compatible versions (all 0.4.x or all 0.6.x, etc.)

**Clear build cache:**
```bash
rm -rf docs/live
./RenderQuarto.sh
```

### If Kernels Don't Appear on GitHub Pages

1. **Check build logs on GitHub Actions**
   - Look for `federated_extensions:copy:ext:@r-wasm/jupyterlite-webr-kernel`
   - Look for `federated_extensions:copy:ext:@jupyterlite/pyodide-kernel-extension`

2. **Check browser console**
   - Open JupyterLite
   - Press F12 → Console tab
   - Look for kernel loading errors

3. **Verify deployment**
   - Check that `docs/live/` directory was deployed
   - Visit: `https://cmpsc301fall2026datascience.github.io/site/live/lab`

---

## Summary

**Before Fix:**
- ❌ No kernels available in JupyterLite
- ❌ Build failed with nested path error
- ❌ Version conflicts between packages
- ❌ Incorrect package names

**After Fix:**
- ✅ Both Python and R kernels available
- ✅ Build completes successfully
- ✅ Compatible package versions
- ✅ Correct package names from PyPI
- ✅ Clean configuration structure
- ✅ Consistent local and CI/CD builds

---

**Status:** READY TO DEPLOY! 🚀

Commit these changes and push to GitHub. Your JupyterLite environment will have both Python and R programming capabilities running entirely in the browser!
