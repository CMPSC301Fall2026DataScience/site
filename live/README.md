# JupyterLite Configuration for CMPSC 301

This directory contains the JupyterLite setup for the Data Science course, providing an in-browser Python and R environment.

## 🚀 What is JupyterLite?

JupyterLite is a Jupyter environment that runs entirely in the browser, requiring no server infrastructure. Students can:
- Write and execute Python code
- Create notebooks with rich markdown
- Use data science libraries (pandas, numpy, matplotlib, etc.)
- Learn and experiment without installations

## 📦 Pre-installed Packages

### Python Packages
- **numpy**: Numerical computing
- **pandas**: Data manipulation and analysis
- **matplotlib**: Static plotting
- **seaborn**: Statistical visualizations
- **plotly**: Interactive visualizations
- **scikit-learn**: Machine learning
- **scipy**: Scientific computing

### R Support
R support in JupyterLite requires additional configuration with the R kernel. This is included via the xeus-r kernel.

## 🛠️ Building JupyterLite

To build and deploy JupyterLite:

1. Install jupyterlite:
   ```bash
   pip install jupyterlite-core
   pip install jupyterlite-pyodide-kernel
   ```

2. Build the site:
   ```bash
   jupyter lite build --output-dir docs/live
   ```

3. The built site will be in `docs/live/` and can be served via GitHub Pages.

## 📚 Adding Content

### Adding Python Packages
Edit `jupyter-lite.json` to add packages to the PyPI environment.

### Adding Example Notebooks
Place `.ipynb` files in `live/content/` directory.

### Custom Configuration
Modify `jupyter_lite_config.json` for advanced settings.

## 🔗 Access

Once deployed, students can access JupyterLite at:
`https://your-github-username.github.io/repo-name/live/`

Or via the navigation menu: **JupyterLite** tab

## 📝 Usage Instructions for Students

1. Click the **JupyterLite** link in the navigation
2. Wait for the environment to load (first load may take 30-60 seconds)
3. Create a new notebook: File → New → Notebook
4. Choose Python kernel
5. Start coding!

## ⚠️ Important Notes

- **All data is stored in browser**: Work is saved in browser local storage
- **Download your work**: Use File → Download to save notebooks
- **Package limitations**: Some packages may not work in the browser environment
- **Performance**: Large datasets may be slow compared to desktop Jupyter

## 🆘 Troubleshooting

**JupyterLite not loading?**
- Clear browser cache
- Try a different browser (Chrome/Firefox recommended)
- Disable browser extensions that block JavaScript

**Package not available?**
- Check if the package is pure Python (no C dependencies)
- Request addition in Discord or GitHub Issues

**Work disappeared?**
- Check Downloads folder (you may have downloaded it)
- Check browser local storage settings
- Always keep backups of important work!

---

For more information, visit [JupyterLite Documentation](https://jupyterlite.readthedocs.io/)
