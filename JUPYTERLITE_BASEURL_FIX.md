# JupyterLite baseUrl Fix

## Problem

JupyterLite was loading on GitHub Pages but **not showing the notebooks work area**. The interface would display but remain blank or show only the loading indicator without the actual workspace.

## Root Cause

When JupyterLite is deployed to a **subdirectory** on GitHub Pages (like `/site/live/`), it needs to know its deployment path. Without the correct `baseUrl` configuration, JupyterLite cannot:
- Load its JavaScript bundles correctly
- Find static resources
- Initialize the workspace interface
- Load extensions and kernels

## Solution

Added the `baseUrl` configuration to `jupyter-lite.json` using a **relative path**:

```json
{
  "jupyter-lite-schema-version": 0,
  "jupyter-config-data": {
    "appName": "CMPSC 301 JupyterLite",
    "appVersion": "0.1.0",
    "appUrl": "./lab",
    "baseUrl": "./",    <--- Using relative path (RECOMMENDED)
    "collaborative": false,
    "disabledExtensions": [],
    "enableMemoryStorage": true,
    "settingsStorageDrivers": ["localStorage"]
  },
  "jupyter-lite": {
    "litePluginSettings": {
      "@jupyterlite/pyodide-kernel-extension:kernel": {
        "pipliteUrls": ["https://pypi.org/pypi/{package_name}/json"],
        "disablePyPIFallback": false
      }
    }
  }
}
```

### Why Relative Path?

Using `"baseUrl": "./"` instead of an absolute path like `"/site/live/"` is **more flexible** because:
- ✅ Works regardless of the exact GitHub Pages deployment path
- ✅ Doesn't break if you rename the repository or move files
- ✅ Works in both production and local testing environments
- ✅ JupyterLite resolves resources relative to where it's served from

## What Changed

1. **Added `baseUrl: "./"`** to `jupyter-lite.json`
2. **Rebuilt JupyterLite** with the corrected configuration
3. **Committed and pushed** the updated build to GitHub

## Deployment Path

Your JupyterLite deployment structure:
- **Site URL**: https://CMPSC301Fall2026DataScience.github.io/site/
- **JupyterLite URL**: https://CMPSC301Fall2026DataScience.github.io/site/live/
- **Lab Interface**: https://CMPSC301Fall2026DataScience.github.io/site/live/lab/

## ⚠️ CRITICAL: Build Order Matters

**ALWAYS** build in this order:

1. **First**: Run `quarto render`
2. **Second**: Run `jupyter lite build --output-dir docs/live`

If you run Quarto render AFTER building JupyterLite, it will **wipe out** the JupyterLite files in `docs/live/`.

### Use the Build Script

To ensure correct build order, use the provided script:

```bash
./build_jupyterlite.sh
```

Or manually:

```bash
# 1. Render Quarto first
quarto render

# 2. Then build JupyterLite
jupyter lite build --output-dir docs/live

# 3. Commit and push
git add docs/live jupyter-lite.json
git commit -m "Update JupyterLite build"
git push
```

### GitHub Actions Workflow

The `.github/workflows/deploy.yml` file already has the correct build order:

```yaml
- name: Render Quarto site
  run: |
    quarto render

- name: Build JupyterLite with Python and WebR
  run: |
    jupyter lite build --output-dir docs/live
```

## Verification

After GitHub Actions completes the deployment (usually 2-3 minutes), verify the fix:

1. Go to: https://CMPSC301Fall2026DataScience.github.io/site/
2. Click the "JupyterLite" link in the navbar
3. The JupyterLite interface should now **fully load and show the work area**
4. You should see:
   - File browser on the left
   - Launcher panel with options to create notebooks
   - Menu bar and toolbar at the top
   - Full functional workspace

## Testing Locally

To test locally before deployment:

```bash
cd /path/to/site_301F2026
jupyter lite build --output-dir docs/live
cd docs/live
python3 -m http.server 8000
```

Then open: http://localhost:8000/

**Note**: Local testing may not perfectly replicate the GitHub Pages subdirectory behavior, but the interface should load and function correctly.

## Why This Fix Works

The `baseUrl` setting tells JupyterLite:
- Where to find its JavaScript bundles (relative to current location)
- Where to load extensions from (relative paths)
- How to construct URLs for API calls
- Where to find static resources (icons, manifests, etc.)

Using a **relative baseUrl** (`./`) means JupyterLite dynamically determines its location based on where it's served, making it portable across different deployment environments.

## Future Deployments

The relative baseUrl `"./"` should work for most deployments. If you need to change it:

- **Relative** (recommended): `"baseUrl": "./"`
- **Root deployment**: `"baseUrl": "/"`
- **Custom subdirectory**: `"baseUrl": "/your/path/"` (include trailing slash!)

Then rebuild with:
```bash
jupyter lite build --output-dir docs/live
```

## Related Files

- **Configuration**: `jupyter-lite.json` (source)
- **Build output**: `docs/live/jupyter-lite.json` (generated)
- **Build script**: `build_jupyterlite.sh`
- **Workflow**: `.github/workflows/deploy.yml`
- **Quarto config**: `_quarto.yml` (navbar link)

## Status

✅ **Fixed and deployed** as of 2026-07-31

The JupyterLite interface should now load completely and display the full work area on GitHub Pages.
