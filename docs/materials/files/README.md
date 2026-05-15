# Course Materials Files Directory

This directory contains all downloadable materials for the course, including:

- **datasets/**: CSV, JSON, Excel files for labs and projects
- **starter_code/**: Python and R template files
- **tutorials/**: PDF guides and Jupyter notebooks
- **examples/**: Sample code and completed projects

## Organization

Files are organized by assignment:

```
files/
├── datasets/
│   ├── sample_sales_data.csv
│   ├── student_performance.csv
│   └── ...
├── starter_code/
│   ├── analysis_template.py
│   ├── ml_pipeline_template.py
│   └── ...
├── tutorials/
│   ├── python_setup_guide.pdf
│   ├── pandas_cheatsheet.pdf
│   └── ...
└── examples/
    ├── visualization_examples.ipynb
    └── ...
```

## Adding New Files

1. Place files in the appropriate subdirectory
2. Update `1_project_files.qmd` with links to new files
3. Commit and push to make available to students

## File Size Considerations

- Keep individual files under 10 MB when possible
- For larger datasets, consider:
  - Hosting on external services (Kaggle, Google Drive)
  - Providing download links instead of direct files
  - Using compressed formats (gzip, zip)

## Access

All files in this directory are automatically included in the website build via the `resources` setting in `_quarto.yml`:

```yaml
project:
  resources:
    - materials/files/**
```

Students can access files at:
`https://your-site.github.io/materials/files/[path-to-file]`
