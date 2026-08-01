# JupyterLite Kernel Fix - No Kernels Available ✅

## Problem Identified

After pushing to GitHub Pages, JupyterLite opened but showed **no kernels available** (neither Python nor R).

### Root Cause
The build process failed with:
```
FileNotFoundError: [Errno 2] No such file or directory: 
'/home/runner/work/site/site/docs/live/live/jupyter-lite.json'
```

Notice the duplicate `/live/live/` path - this occurred because:

1. **Two `jupyter-lite.json` files existed:**
   - `/jupyter-lite.json` (project root)
   - `/live/jupyter-lite.json` (subdirectory)

2. **JupyterLite tried to patch both files:**
   - Root config → `docs/live/jupyter-lite.json` ✅
   - Live config → `docs/live/live/jupyter-lite.json` ❌ (path doesn't exist)

3. **Build failed before kernels were installed**, resulting in a JupyterLite instance with no Python or R kernels.

## Solution Applied

### 1. Merged Configuration Files
Combined both `jupyter-lite.json` configurations into the root file:
- ✅ Kept `baseUrl: "/live/"` for GitHub Pages
- ✅ Added app name and settings from `live/` config
- ✅ Retained Pyodide CDN URLs for better performance
- ✅ Added proper settings for both Python and R kernels

**Result:** Single, unified configuration at [jupyter-lite.json](jupyter-lite.json)

### 2. Removed Duplicate Config
Renamed `live/jupyter-lite.json` → `live/jupyter-lite.json.backup` to prevent conflicts.

### 3. Aligned Build Commands
Updated [RenderQuarto.sh](RenderQuarto.sh) to match the GitHub Actions workflow:

**Before (local script):**
```bash
cd live
jupyter lite build --contents content --output-dir ../docs/live
```

**After (aligned with GitHub Actions):**
```bash
jupyter lite build --contents live/content --output-dir docs/live
```

Both now run from the project root with identical paths.

### 4. Updated .gitignore
Added backup files to [.gitignore](.gitignore):
```
*.json.backup
```

## Files Changed

| File | Change |
|------|--------|
| [jupyter-lite.json](jupyter-lite.json) | Merged both configs, added app settings |
| [live/jupyter-lite.json](live/jupyter-lite.json) | Renamed to `.backup` (removed from build) |
| [RenderQuarto.sh](RenderQuarto.sh) | Updated build command to match GitHub Actions |
| [.gitignore](.gitignore) | Added `*.json.backup` pattern |

## Testing the Fix

### Local Testing
```bash
# Build the site
./RenderQuarto.sh

# Check the output
ls docs/live/  # Should see jupyter-lite.json (no nested live/ dir)

# Open in browser
open docs/index.html
# Navigate to JupyterLite - both Python and R kernels should appear
```

### GitHub Pages Deploy
```bash
# Commit changes
git add .
git commit -m "Fix JupyterLite kernel loading - resolve duplicate config issue"
git push origin main

# Wait for GitHub Actions to complete
# Check your site - kernels should now be available
```

## Expected Behavior After Fix

When you open JupyterLite on GitHub Pages:

1. **Python kernel available** (Pyodide)
   - Can create new Python notebooks
   - Packages installable via `micropip`

2. **R kernel available** (WebR)
   - Can create new R notebooks
   - Select "R (WebR)" kernel
   - Packages installable via `install.packages()`

3. **Sample notebooks load correctly:**
   - [welcome.ipynb](live/content/welcome.ipynb) - Python
   - [r_example.ipynb](live/content/r_example.ipynb) - R

## Why This Happened

The duplicate configuration arose from having:
- An original root `jupyter-lite.json` for GitHub Pages deployment
- A new `live/jupyter-lite.json` created for the JupyterLite build

When JupyterLite scans for config files, it finds **all** `jupyter-lite.json` files in the project and tries to patch them relative to the output directory, causing the path duplication error.

## Prevention

**Best Practice:** Keep only **one** `jupyter-lite.json` at the project root. Additional settings can be managed through:
- Command-line flags
- Environment variables
- Jupyter config files (not `jupyter-lite.json`)

---

**Status:** Ready to commit and deploy! 🚀

The build should now complete successfully and both Python and R kernels will be available in your JupyterLite environment on GitHub Pages.
