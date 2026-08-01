# JupyterLite Build Fixes - GitHub Actions & Path Issues

## Date: 2026-07-31

## Issues Fixed

### 1. Double Path Error (`docs/live/live/jupyter-lite.json`)
**Problem**: Build was trying to write to `/docs/live/live/jupyter-lite.json` (double `live/`)

**Root Cause**: The build scripts were:
1. Using `cd live` to change into the live directory
2. Then running `jupyter lite build --output-dir ../docs/live`
3. When JupyterLite found `live/jupyter-lite.json`, it tried to preserve the path structure, creating `docs/live/live/jupyter-lite.json`

**Solution**:
- Changed build command from `cd live && jupyter lite build --output-dir ../docs/live` 
- To: `jupyter lite build --lite-dir live --output-dir docs/live`
- Removed `live/jupyter-lite.json` (not needed, we use root `jupyter-lite.json` instead)
- Moved `jupyter_lite_config.json` into `live/` directory

### 2. Version Compatibility Warning
**Problem**: 
```
jupyterlite-pyodide-kernel 0.8.2 requires jupyterlite-core>=0.8.1, 
but you have jupyterlite-core 0.6.4 which is incompatible.
```

**Root Cause**: 
- Installing packages in wrong order caused version conflicts
- WebR kernel has specific version requirements

**Solution**:
- Reorganized GitHub Actions installation order:
  1. Install base packages (jupyter, numpy, pandas, etc.)
  2. Install WebR kernel (which pulls in its required jupyterlite-core version)
  3. Upgrade jupyterlite packages to ensure compatibility
  
This lets the WebR kernel dictate the compatible versions rather than forcing specific versions.

## Files Modified

### Build Scripts
1. **[RenderQuarto.sh](../RenderQuarto.sh)**
   - Changed: `cd live && jupyter lite build --output-dir ../docs/live`
   - To: `jupyter lite build --lite-dir live --output-dir docs/live`
   - Removed `cd` commands

2. **[build_jupyterlite.sh](../build_jupyterlite.sh)**
   - Same changes as RenderQuarto.sh
   - Uses `--lite-dir live` flag instead of changing directory

### Configuration Files
3. **[jupyter_lite_config.json](../live/jupyter_lite_config.json)**
   - Moved from root to `live/` directory
   - Removed `base_url` setting (now using command-line flag)
   - Simplified `contents` path to just `["content"]` (relative to lite-dir)

4. **Removed: `live/jupyter-lite.json`**
   - This file was causing the double-path issue
   - Root `jupyter-lite.json` is sufficient

### GitHub Actions
5. **[.github/workflows/deploy.yml](../.github/workflows/deploy.yml)**
   - Fixed installation order to avoid version conflicts
   - Added separate step for JupyterLite package upgrades
   - Updated build command to use `--lite-dir live`
   - Added post-build baseUrl fix step

## Changes Summary

### Before (Broken)
```bash
cd live
jupyter lite build --output-dir ../docs/live
cd ..
```
Result: Created `docs/live/live/jupyter-lite.json` ❌

### After (Fixed)  
```bash
jupyter lite build --lite-dir live --output-dir docs/live --base-url /site/live/
```
Result: Creates `docs/live/jupyter-lite.json` ✅

## Testing Locally

```bash
# Clean build
rm -rf docs/live/*

# Run full build
sh RenderQuarto.sh

# Verify no double paths
ls docs/live/live/  # Should show "No such file or directory"

# Verify baseUrl
python3 -c "import json; print(json.load(open('docs/live/jupyter-lite.json'))['jupyter-config-data']['baseUrl'])"
# Should output: /site/live/
```

## Deployment Steps

### 1. Commit Changes
```bash
git add .github/workflows/deploy.yml \
        RenderQuarto.sh \
        build_jupyterlite.sh \
        live/jupyter_lite_config.json \
        docs/live/ \
        notes/

git commit -m "Fix: JupyterLite build path issues and version compatibility"
```

### 2. Push to GitHub
```bash
git push origin main
```

### 3. Monitor GitHub Actions
- Go to: https://github.com/CMPSC301Fall2026DataScience/site/actions
- Watch the build progress
- Should complete without errors in ~3-5 minutes

### 4. Verify Deployment
After successful build, test:
- https://CMPSC301Fall2026DataScience.github.io/site/live/lab/

**Important**: Clear browser cache or use incognito mode if previously visited.

## Expected GitHub Actions Build Output

The build should now:
1. ✅ Install Python dependencies
2. ✅ Install WebR kernel (with compatible jupyterlite-core)
3. ✅ Upgrade jupyterlite packages
4. ✅ Render Quarto site
5. ✅ Build JupyterLite with correct paths
6. ✅ Fix baseUrl for GitHub Pages
7. ✅ Deploy to GitHub Pages

## Troubleshooting

### If Build Still Fails

**Check 1: Verify no double paths**
```bash
# In your repo
find docs/live -name "*.json" | grep -E "live/live"
# Should return nothing
```

**Check 2: Verify config location**
```bash
ls -la live/jupyter_lite_config.json
# Should exist
ls -la jupyter_lite_config.json  
# Should NOT exist (moved to live/)
```

**Check 3: Check GitHub Actions logs**
Look for:
- `FileNotFoundError: [Errno 2] No such file or directory: '...docs/live/live/jupyter-lite.json'`
  - If you see this, the fix didn't apply. Check that deploy.yml has `--lite-dir live`
  
- Version conflict warnings
  - These are just warnings, build should still succeed
  - If build fails, check installation order in deploy.yml

### If JupyterLite Doesn't Load

1. **Hard refresh**: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows/Linux)
2. **Check baseUrl**: Should be `/site/live/` in `docs/live/jupyter-lite.json`
3. **Check browser console** (F12): Look for 404 errors or service worker issues

## Version Management

### Local Development
Your local environment may have different versions than GitHub Actions. This is OK as long as:
- ✅ Local builds complete successfully
- ✅ `sh RenderQuarto.sh` works without errors
- ✅ GitHub Actions builds complete successfully

### GitHub Actions
The workflow now installs packages in this order:
1. Base packages (jupyter, numpy, pandas, etc.)
2. WebR kernel (brings compatible jupyterlite-core)
3. Upgrade jupyterlite packages

This ensures version compatibility automatically.

## Key Takeaways

1. **Never `cd` into a directory before building JupyterLite**
   - Use `--lite-dir` flag instead
   - Prevents path duplication issues

2. **Configuration goes in the lite directory**
   - `jupyter_lite_config.json` → `live/jupyter_lite_config.json`
   - Paths in config are relative to lite-dir

3. **Let WebR kernel manage versions**
   - Don't pin specific jupyterlite versions
   - Let the WebR kernel pull compatible versions

4. **Post-build baseUrl fix is essential**
   - JupyterLite generates relative paths by default
   - Must update to absolute path for GitHub Pages subdirectory

## References

- [JupyterLite CLI Documentation](https://jupyterlite.readthedocs.io/en/latest/reference/cli.html)
- [WebR Kernel Repository](https://github.com/r-wasm/jupyterlite-webr-kernel)
- Previous fix: [JUPYTERLITE_GITHUB_PAGES_FIX.md](JUPYTERLITE_GITHUB_PAGES_FIX.md)
