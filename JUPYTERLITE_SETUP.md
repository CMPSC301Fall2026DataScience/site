# Adding JupyterLite (Python + R) to a Quarto site on GitHub Pages

A reusable recipe for putting a browser-based Jupyter environment with **both a
Python kernel and an R kernel** at `https://your-site/live/`, alongside a Quarto
website, deployed by GitHub Actions to GitHub Pages.

Nothing runs on a server. Python executes via [Pyodide](https://pyodide.org)
(WebAssembly CPython) and R via [webR](https://docs.r-wasm.org/webr/latest/)
(WebAssembly R), both inside the student's browser tab.

---

## 1. How the pieces fit together

Two independent builds write into one output directory, then that directory is
published as the Pages artifact:

```
quarto render          ──>  docs/          (the website)
jupyter lite build     ──>  docs/live/     (the JupyterLite app)
                            └─ uploaded together by actions/upload-pages-artifact
```

Order matters. `quarto render` prunes stale files from its output directory, so
it must run **before** the JupyterLite build, never after.

The JupyterLite build must run with `live/` as its working directory. That is
what keeps its config files from colliding with the Quarto project, and it is
why the output path is written as `../docs/live`.

---

## 2. Files you need

Four small files under a `live/` directory. That is the whole configuration.

```
live/
├── requirements.txt          # build-time pins (see §3 -- the part people get wrong)
├── jupyter_lite_config.json  # build-time settings
├── jupyter-lite.json         # runtime settings shipped into the app
└── content/                  # starter notebooks copied into the app
```

### `live/requirements.txt`

```
jupyterlite-core[lab]==0.6.4
jupyterlite-pyodide-kernel==0.6.1
jupyterlite-webr==0.6.0
```

### `live/jupyter_lite_config.json`

```json
{
  "LiteBuildConfig": {
    "contents": ["content"]
  }
}
```

That is genuinely all that belongs here. **Do not add `ignore_sys_prefix`** —
see §5.

### `live/jupyter-lite.json`

Runtime config baked into the deployed app. Only override what you actually want
to change:

```json
{
  "jupyter-lite-schema-version": 0,
  "jupyter-config-data": {
    "appName": "My Course JupyterLite"
  }
}
```

You can omit this file entirely and get sensible defaults.

### `live/content/`

Any `.ipynb` and data files here are copied into the app and appear in the file
browser. To make a notebook open with R rather than Python, its metadata must
name the webR kernel:

```json
"metadata": {
  "kernelspec": {
    "name": "webR",
    "display_name": "R (webR)",
    "language": "R"
  }
}
```

The kernel names to use are `python` (Pyodide) and `webR` (webR). A notebook
with no `kernelspec` defaults to Python.

---

## 3. Version pinning — the constraint that actually bites

The three packages are **not independently versionable**. Each kernel declares a
hard range on `jupyterlite-core`:

| Package | Latest | Requires |
|---|---|---|
| `jupyterlite-core` | 0.8.x | — |
| `jupyterlite-pyodide-kernel` | 0.8.x | `jupyterlite-core >=0.8.2,<0.9` |
| `jupyterlite-webr` | **0.6.0** | `jupyterlite-core >=0.6,<0.7` |

`jupyterlite-webr` releases more slowly than the rest of the stack, so **it
decides the version of everything else**. As long as its newest release is
0.6.0, the whole stack is pinned to the 0.6 line — you cannot run the latest
`jupyterlite-core` and still have an R kernel.

To re-check the ceiling before bumping:

```bash
curl -s https://pypi.org/pypi/jupyterlite-webr/json \
  | python3 -c "import json,sys; d=json.load(sys.stdin); \
      print(d['info']['version'], d['info']['requires_dist'][0])"
```

Then pick the matching `jupyterlite-core` and `jupyterlite-pyodide-kernel`
minor line and pin all three with `==`.

Pinning loosely (`>=0.4,<0.6` and friends) is what produces the classic failure:
pip resolves a combination that installs cleanly but ships an app with no
kernels.

> **Note on the package name.** The PyPI project is `jupyterlite-webr`. The
> older name `jupyterlite-webr-kernel` refers to the *npm/labextension* package
> (`@r-wasm/jupyterlite-webr-kernel`) and does not exist on PyPI — `pip install
> jupyterlite-webr-kernel` will always fail.

---

## 4. The GitHub Actions workflow

`.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy Quarto Site with JupyterLite

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - uses: quarto-dev/quarto-actions/setup@v2
        with:
          version: 'release'

      - name: Install JupyterLite and kernels
        run: pip install -r live/requirements.txt

      - name: Render Quarto site to docs/
        run: quarto render

      - name: Build JupyterLite (Python + R) into docs/live
        working-directory: live
        run: jupyter lite build --output-dir ../docs/live

      - uses: actions/upload-pages-artifact@v3
        with:
          path: docs

  deploy:
    if: github.ref == 'refs/heads/main'
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

Supporting settings:

- `_quarto.yml` must have `output-dir: docs` to match the artifact path.
- In the repo, **Settings → Pages → Source** must be set to **GitHub Actions**
  (not "Deploy from a branch").
- `.gitignore` should contain `docs/` and `.jupyterlite.doit.db` (see §5).

Link to it from your Quarto navbar:

```yaml
website:
  navbar:
    left:
      - href: /live/
        text: JupyterLite
        target: _blank
```

---

## 5. Two traps that produce "the app loads but has no kernels"

This is the single most common symptom, and it has two distinct causes. Both
fail *silently* — the build exits 0 and the JupyterLab UI renders normally, but
the kernel picker is empty and notebooks never connect.

### Trap 1: `ignore_sys_prefix: true`

```json
{ "LiteBuildConfig": { "ignore_sys_prefix": true } }   // ← deletes your kernels
```

Both kernels ship as JupyterLab *federated extensions*, installed into
`sys.prefix/share/jupyter/labextensions/`. `ignore_sys_prefix` tells the build
to ignore that entire directory, so the kernels are never bundled. You get a
working JupyterLab shell that can run nothing.

Symptom in the build log: no `extensions/` directory in the output, and no
`federated_extensions:*` entries mentioning the kernels.

**Fix:** remove the setting. It has no legitimate use in this workflow.

### Trap 2: a committed `.jupyterlite.doit.db`

`jupyter lite build` caches its task graph in `.jupyterlite.doit.db`. If that
file is committed, CI restores a cache describing a *previous* environment —
often one built with different package versions — and doit skips the steps that
copy the kernels in.

**Fix:** `git rm --cached .jupyterlite.doit.db` and add it to `.gitignore`.

### Verifying the fix

The build output is checkable without a browser. Both kernel extensions must be
present:

```bash
ls docs/live/extensions/*/
# expect: @jupyterlite/pyodide-kernel-extension
#         @r-wasm/jupyterlite-webr-kernel

python3 -c "import json; print([e['name'] for e in \
  json.load(open('docs/live/jupyter-lite.json'))['jupyter-config-data']['federated_extensions']])"
```

If those two names appear, the kernels will load.

---

## 6. Building and previewing locally

```bash
quarto render
pip install -r live/requirements.txt
cd live && jupyter lite build --output-dir ../docs/live && cd ..

python3 -m http.server -d docs 8000
# then open http://localhost:8000/live/
```

You **must** use an HTTP server. Opening `docs/live/index.html` over `file://`
fails — the service worker and the WASM kernels both require a real origin.

If a local build ever behaves oddly, delete `live/.jupyterlite.doit.db` and
rebuild; that clears the task cache described in Trap 2.

---

## 7. Packages inside the browser

Nothing in `live/requirements.txt` is available to student notebooks. That file
describes the *build machine*. Packages are fetched at runtime, in the tab:

**Python** — a set of scientific wheels ships with Pyodide (`numpy`, `pandas`,
`matplotlib`, `scipy`, `scikit-learn`, …) and imports directly. Anything else:

```python
import micropip
await micropip.install("seaborn")
```

`micropip` falls back to PyPI by default, so pure-Python and WASM-compatible
wheels both work. Packages with compiled C extensions that Pyodide has not built
will not install.

**R** — base R is bundled. Additional packages come from the webR CRAN mirror:

```r
install.packages("ggplot2")
library(ggplot2)
```

Only packages webR has compiled to WASM are available; see the
[webR package list](https://repo.r-wasm.org/).

---

## 8. Notes for students using the site

- First load takes 30–60 seconds while the WASM runtime downloads; later loads
  are cached.
- Work is saved in **browser storage**, not on a server. Clearing site data
  erases it. Use *File → Download* to keep anything that matters.
- Switch languages per notebook with *Kernel → Change Kernel*.
- Chrome and Firefox are the best-tested browsers.

---

## Reference

- [JupyterLite docs](https://jupyterlite.readthedocs.io/)
- [jupyterlite-pyodide-kernel](https://github.com/jupyterlite/pyodide-kernel)
- [jupyterlite-webr](https://github.com/r-wasm/jupyterlite-webr-kernel)
- [Quarto: publishing to GitHub Pages](https://quarto.org/docs/publishing/github-pages.html)
