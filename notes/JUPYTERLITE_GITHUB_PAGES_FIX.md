# JupyterLite GitHub Pages Loading Fix

## Date: 2026-07-31

## Problem
JupyterLite showed only a loading screen on GitHub Pages but never displayed the notebook client interface. The site renders correctly locally but fails when deployed to GitHub Pages at `https://CMPSC301Fall2026DataScience.github.io/site/live/`.

## Root Cause
When JupyterLite is deployed to a **subdirectory** on GitHub Pages (like `/site/live/`), it must know its exact deployment path. The previous configuration used a relative `baseUrl: "./"` which works for root deployments but fails for subdirectory deployments because:

1. The service worker cannot correctly resolve resource paths
2. JavaScript bundles and static assets load from incorrect URLs
3. The application fails to initialize even though the loading screen appears

## Solution

### 1. Created Configuration in Source Directory
Created `live/jupyter-lite.json` with the absolute base URL:

```json
{
  "jupyter-lite-schema-version": 0,
  "jupyter-config-data": {
    "appName": "CMPSC 301 JupyterLite",
    "appVersion": "0.1.0",
    "appUrl": "./lab",
    "baseUrl": "/site/live/",
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

### 2. Updated Build Scripts
Modified both `RenderQuarto.sh` and `build_jupyterlite.sh` to include the `--base-url` flag:

```bash
jupyter lite build --output-dir ../docs/live --base-url /site/live/
```

### 3. Updated Root Configuration
Updated the root `jupyter-lite.json` to also use the absolute path for consistency.

## Key Points

### Why Absolute Path for Subdirectory Deployment?
- **Root deployment** (`https://user.github.io/`): Can use `"baseUrl": "./"`
- **Subdirectory deployment** (`https://user.github.io/site/`): Must use `"baseUrl": "/site/live/"`

The absolute path ensures:
- Service worker registers with correct scope
- All resource URLs resolve correctly
- JavaScript modules load from the right location
- API endpoints are properly routed

### Build Process
The JupyterLite build process now:
1. Reads the `live/jupyter-lite.json` configuration
2. Merges it with any existing configurations
3. Uses the `--base-url` flag to configure internal routing
4. Outputs to `docs/live/` with the correct baseUrl

## Deployment URLs
- **Site Base**: `https://CMPSC301Fall2026DataScience.github.io/site/`
- **JupyterLite**: `https://CMPSC301Fall2026DataScience.github.io/site/live/`
- **Lab Interface**: `https://CMPSC301Fall2026DataScience.github.io/site/live/lab/`
- **REPL**: `https://CMPSC301Fall2026DataScience.github.io/site/live/repl/`

## Testing

### Local Testing
To test locally with the correct paths:

```bash
cd docs/live
python3 -m http.server 8000
```

Then access: `http://localhost:8000/site/live/`

Note: You need to access it with the `/site/live/` path structure to simulate GitHub Pages deployment.

### GitHub Pages Testing
After committing and pushing:

```bash
git add docs/live live/jupyter-lite.json jupyter-lite.json
git add RenderQuarto.sh build_jupyterlite.sh
git commit -m "Fix JupyterLite baseUrl for GitHub Pages subdirectory deployment"
git push
```

Wait 1-2 minutes for GitHub Actions to deploy, then test:
- Direct lab access: `https://CMPSC301Fall2026DataScience.github.io/site/live/lab/`

### Clearing Cache
If you've previously visited the page, you may need to:
1. Hard refresh: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+R` (Windows/Linux)
2. Clear browser cache and cookies for the site
3. Open in incognito/private mode

## What Changed

### Files Modified
1. `live/jupyter-lite.json` - Created with absolute baseUrl
2. `jupyter-lite.json` - Updated with absolute baseUrl
3. `RenderQuarto.sh` - Added `--base-url /site/live/` flag
4. `build_jupyterlite.sh` - Added `--base-url /site/live/` flag and fixed directory context

### Files Generated
- `docs/live/jupyter-lite.json` - Now has `"baseUrl": "/site/live/"`
- All other `docs/live/` files regenerated with correct configuration

## Future Maintenance

### If Repository Name Changes
If you rename the repository from "site" to something else (e.g., "course-site"), update:

1. `live/jupyter-lite.json` - Change `"baseUrl": "/new-name/live/"`
2. `jupyter-lite.json` - Change `"baseUrl": "/new-name/live/"`
3. Both build scripts - Update `--base-url /new-name/live/`
4. Rebuild: `sh RenderQuarto.sh`

### If Moving JupyterLite Location
If you move JupyterLite to a different path:
- Update the baseUrl to match the new path
- Update the `--output-dir` in build scripts
- Update the `_quarto.yml` navbar link

## References
- [JupyterLite Documentation](https://jupyterlite.readthedocs.io/)
- [JupyterLite GitHub Pages Deployment](https://jupyterlite.readthedocs.io/en/latest/howto/deployment/github-pages.html)
- Previous fix attempts: See `JUPYTERLITE_BASEURL_FIX.md` for earlier relative path approach
