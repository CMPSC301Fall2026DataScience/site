# JupyterLite for CMPSC 301

This directory builds the in-browser Jupyter environment published at
[`/live/`](https://dodatascience.com/live). Python and R both run entirely in
the student's browser — there is no server and nothing to install.

For the portable, step-by-step version of this setup (intended for reuse on
other Quarto sites), see [../JUPYTERLITE_SETUP.md](../JUPYTERLITE_SETUP.md).

## Layout

| File | Purpose |
|---|---|
| `requirements.txt` | Build-time pins. Installed on the build machine, **not** in the browser. |
| `jupyter_lite_config.json` | Build-time settings — just points at `content/`. |
| `jupyter-lite.json` | Runtime settings baked into the app (app name). |
| `content/` | Starter notebooks copied into the deployed file browser. |

## Kernels

| Kernel | Name | Language |
|---|---|---|
| Pyodide | `python` | Python 3 (WebAssembly CPython) |
| webR | `webR` | R (WebAssembly R) |

Switch between them with *Kernel → Change Kernel*. A notebook in `content/`
opens with Python unless its metadata names the `webR` kernel — see
`content/r_example.ipynb` for a working example.

## Building

From the repository root, `./RenderQuarto.sh` does everything. Manually:

```bash
pip install -r live/requirements.txt
cd live && jupyter lite build --output-dir ../docs/live
```

Preview over HTTP — `file://` will not work:

```bash
python3 -m http.server -d docs 8000   # then open http://localhost:8000/live/
```

## Adding content

Drop `.ipynb` or data files into `content/` and rebuild. They appear in the
student-facing file browser.

## Installing packages inside notebooks

Python:

```python
import micropip
await micropip.install("seaborn")
```

`numpy`, `pandas`, `matplotlib`, `scipy`, and `scikit-learn` are bundled with
Pyodide and import without any install step.

R:

```r
install.packages("ggplot2")
```

Only packages compiled to WebAssembly are available — see
[repo.r-wasm.org](https://repo.r-wasm.org/) for the R list.

## Version constraints

`jupyterlite-webr` moves more slowly than the rest of the stack and pins
`jupyterlite-core >=0.6,<0.7`, so all three packages are held on the 0.6 line.
Bumping one without the others removes the kernels from the build. Details in
[../JUPYTERLITE_SETUP.md](../JUPYTERLITE_SETUP.md) §3.

## If the kernel list comes up empty

Check the two silent failure modes documented in
[../JUPYTERLITE_SETUP.md](../JUPYTERLITE_SETUP.md) §5: `ignore_sys_prefix` in
`jupyter_lite_config.json`, and a committed `.jupyterlite.doit.db`. Then verify
the build output:

```bash
ls docs/live/extensions/*/
# expect @jupyterlite/pyodide-kernel-extension and @r-wasm/jupyterlite-webr-kernel
```

## Notes for students

- First load takes 30–60 seconds; subsequent loads are cached.
- Work lives in **browser storage**. Clearing site data erases it — use
  *File → Download* to keep anything important.
- Chrome and Firefox are best supported.
