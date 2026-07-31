# CMPSC 301: Data Science - Fall 2026

![Course Logo](logo.png)

**Allegheny College | Department of Computer Science**

A comprehensive, interactive course website for Data Science (CMPSC 301) featuring JupyterLite integration, interactive Python/R demonstrations, and a colorful, student-friendly design.

## 🌟 Features

- **🎨 Colorful Design**: Vibrant UI inspired by the course logo (cyan, coral, deep blue)
- **🚀 JupyterLite Integration**: Full Python environment running in the browser
- **🎮 Interactive Playground**: 5 comprehensive data science demonstrations:
  - Data Visualization Masterclass
  - Machine Learning: Predicting the Future
  - Text Analytics & Sentiment Analysis
  - Statistical Analysis: Finding Patterns
  - Data Wrangling: Cleaning Messy Data
- **📚 Course Materials**: Weekly schedule with slides, assignments, and resources
- **📥 Project Files Hub**: Downloadable datasets, starter code, and tutorials
- **📱 Responsive Design**: Works beautifully on desktop, tablet, and mobile

## 🚀 Quick Start

### Option 1: View the Live Site

Visit the deployed site at: `https://YOUR-USERNAME.github.io/YOUR-REPO/`

### Option 2: Build Locally

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
   cd YOUR-REPO
   ```

2. **Install Quarto**:
   - Download from [quarto.org](https://quarto.org/docs/get-started/)
   - Follow installation instructions for your OS

3. **Install Python dependencies** (for JupyterLite):
   ```bash
   pip install jupyterlite-core jupyterlite-pyodide-kernel
   pip install numpy pandas matplotlib seaborn plotly scikit-learn scipy
   ```

4. **Render the site**:
   ```bash
   quarto render
   ```

5. **Build JupyterLite**:
   ```bash
   cd live
   jupyter lite build --output-dir ../docs/live
   ```

6. **Preview locally**:
   ```bash
   quarto preview
   ```
   or open `docs/index.html` in your browser

## 📁 Project Structure

```
.
├── _quarto.yml              # Main Quarto configuration
├── styles.css               # Custom CSS (logo-inspired colors)
├── logo.png                 # Course logo
├── index.qmd                # Home page (syllabus)
├── README.md                # This file
│
├── playground/              # Interactive demonstrations
│   ├── 00_playground.qmd    # Playground landing page
│   ├── 01_visualization.qmd
│   ├── 02_machine_learning.qmd
│   ├── 03_text_analysis.qmd
│   ├── 04_statistical_analysis.qmd
│   └── 05_data_wrangling.qmd
│
├── materials/               # Course materials
│   ├── 0_materials.qmd      # Weekly schedule
│   ├── 1_project_files.qmd  # Downloads hub
│   └── files/               # Datasets and resources
│
├── live/                    # JupyterLite setup
│   ├── jupyter-lite.json
│   ├── jupyter_lite_config.json
│   ├── content/
│   │   └── welcome.ipynb    # Welcome notebook
│   └── README.md
│
├── docs/                    # Built site (output)
│   ├── index.html
│   ├── live/                # JupyterLite deployment
│   └── ...
│
└── .github/
    └── workflows/
        └── deploy.yml       # GitHub Actions for deployment
```

## 🎨 Color Scheme

The site uses colors extracted from the course logo:

- **Bright Cyan**: `#40C9D9` - Primary navigation and accents
- **Deep Blue**: `#2563C7` - Headings and text
- **Coral Pink**: `#FF6B6B` - Highlights and calls-to-action
- **Turquoise**: `#4DD4E5` - Secondary accents
- **Salmon Coral**: `#FF7B7C` - Interactive elements

## 🛠️ Customization

### Changing Colors

Edit `styles.css` and update the CSS variables in `:root`:

```css
:root {
  --bright-cyan: #40C9D9;
  --deep-blue: #2563C7;
  --coral-pink: #FF6B6B;
  /* ... */
}
```

### Adding Pages

1. Create a new `.qmd` file
2. Add it to `_quarto.yml` navigation:
   ```yaml
   navbar:
     left:
       - href: your-page.qmd
         text: Your Page
   ```

### Adding Playground Demonstrations

1. Create a new `.qmd` file in `playground/`
2. Add frontmatter with title, description, and categories
3. It will automatically appear in the playground listing

### Modifying JupyterLite Packages

Edit `live/jupyter_lite_config.json` and add packages to `pypi_wheels`:

```json
{
  "PipliteAddon": {
    "pypi_wheels": [
      "numpy",
      "pandas",
      "your-package-here"
    ]
  }
}
```

## 🚀 Deployment to GitHub Pages

### Automatic Deployment (Recommended)

The repository includes a GitHub Actions workflow that automatically builds and deploys the site when you push to the `main` branch.

**Setup steps**:

1. Go to your repository settings
2. Navigate to **Pages** section
3. Under **Source**, select **GitHub Actions**
4. Push to `main` branch - the site will build automatically!

### Manual Deployment

If you prefer manual deployment:

1. Build the site locally:
   ```bash
   quarto render
   cd live && jupyter lite build --output-dir ../docs/live
   ```

2. Commit and push the `docs/` folder:
   ```bash
   git add docs/
   git commit -m "Deploy site"
   git push
   ```

3. Configure GitHub Pages to use the `docs/` folder

## 📚 Course Content

### Playground Demonstrations

1. **Data Visualization**: Creating beautiful charts with Matplotlib, Seaborn, and Plotly
2. **Machine Learning**: Building predictive models for house prices
3. **Text Analytics**: Sentiment analysis of product reviews
4. **Statistical Analysis**: Hypothesis testing and confidence intervals with student data
5. **Data Wrangling**: Cleaning and transforming messy real-world data

### Materials

- **Weekly schedule** with topics, slides, and assignments
- **Downloadable resources**: Datasets, starter code, tutorials
- **Project guidelines**: Midterm and final project requirements

## 🤝 Contributing

This is a course website template. To adapt it for your course:

1. Fork the repository
2. Update course information in `index.qmd`
3. Customize colors in `styles.css`
4. Add your own materials to `materials/`
5. Modify or add playground demonstrations
6. Update README.md and remove example content

## 📄 License

This course website is open source. Feel free to use and adapt it for your own courses!

## 🆘 Support

- **Technical Issues**: Open an issue on GitHub
- **Course Questions**: Contact the instructor via email or Discord
- **JupyterLite Problems**: See `live/README.md` for troubleshooting

## ✨ Credits

- **Quarto**: [quarto.org](https://quarto.org)
- **JupyterLite**: [jupyterlite.readthedocs.io](https://jupyterlite.readthedocs.io)
- **Design Inspiration**: Course logo colors and modern web design principles
- **Data Science Libraries**: NumPy, Pandas, Matplotlib, Seaborn, Plotly, Scikit-learn

---

**Built with ❤️ for Data Science Education**

*Last updated: August 2026*
