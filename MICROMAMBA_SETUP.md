# Installing Micromamba for R Kernel Support

## The Issue

Building JupyterLite with R support requires **micromamba** to create the WebAssembly environment for xeus-r. Without it, the R kernel won't be built.

## Solution: Install Micromamba

### macOS Installation

```bash
# Using Homebrew (easiest)
brew install micromamba

# Or download directly
curl -Ls https://micro.mamba.pm/api/micromamba/osx-64/latest | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/
```

### Verify Installation

```bash
micromamba --version
```

### After Installing Micromamba

1. Run the build script again:
   ```bash
   cd /Users/obonhamcarter/Desktop/src/3_web/classes/Cs301F2026/site_301F2026
   ./build_jupyterlite.sh
   ```

2. The build will now create the R environment (this may take 5-10 minutes on first build)

3. After successful build, check for R kernel:
   ```bash
   ls -la docs/live/kernelspecs/
   ```
   
   You should see both `python` and `xr` (R) directories.

## Alternative: Use GitHub Actions

If you don't want to install micromamba locally, you can use GitHub Actions to build the site. Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy JupyterLite

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install Micromamba
        uses: mamba-org/setup-micromamba@v1
        with:
          micromamba-version: latest
          environment-name: build-env
          create-args: python=3.11
      
      - name: Install JupyterLite
        run: |
          pip install jupyterlite-core jupyterlite-pyodide-kernel jupyterlite-xeus jupyterlite quarto
      
      - name: Build JupyterLite
        run: |
          cd ${{ github.workspace }}
          ./build_jupyterlite.sh
      
      - name: Render Quarto
        run: quarto render
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

This way, the build happens in GitHub's environment with micromamba pre-installed.

## Simplified Alternative: Python-Only Approach

If micromamba setup is too complex, you can:

1. Keep JupyterLite Python-only for now
2. Provide R through alternative methods:
   - RStudio Cloud links
   - Posit Cloud
   - Local R/RStudio installation instructions
   - Use rpy2 bridge from Python (limited functionality)

Let me know which approach you prefer!
