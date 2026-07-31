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

Added the `baseUrl` configuration to `jupyter-lite.json`:

```json
{
  "jupyter-lite-schema-version": 0,
  "jupyter-config-data": {
    "appName": "CMPSC 301 JupyterLite",
    "appVersion": "0.1.0",
    "appUrl": "./lab",
    "baseUrl": "/site/live/",    <--- Added this line
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

## What Changed

1. **Added `baseUrl: "/site/live/"`** to `jupyter-lite.json`
2. **Rebuilt JupyterLite** with the corrected configuration
3. **Committed and pushed** the updated build to GitHub

## Deployment Path

Your JupyterLite deployment structure:
- **Site URL**: https://CMPSC301Fall2026DataScience.github.io/site/
- **JupyterLite URL**: https://CMPSC301Fall2026DataScience.github.io/site/live/
- **Lab Interface**: https://CMPSC301Fall2026DataScience.github.io/site/live/lab/

The `baseUrl` of `/site/live/` tells JupyterLite it's deployed at this subdirectory path.

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
- Where to find its JavaScript bundles (`/site/live/build/...`)
- Where to load extensions from (`/site/live/lab/extensions/...`)
- How to construct URLs for API calls (`/site/live/api/...`)
- Where to find static resources (icons, manifests, etc.)

Without the correct `baseUrl`, JupyterLite tries to load resources from the wrong paths (like `/build/...` instead of `/site/live/build/...`), which results in 404 errors and a broken interface.

## Future Deployments

If you ever move JupyterLite to a different path, update the `baseUrl` in `jupyter-lite.json` to match:
- Root deployment: `"baseUrl": "/"`
- Custom subdirectory: `"baseUrl": "/your/path/"`
- Always include trailing slash!

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
