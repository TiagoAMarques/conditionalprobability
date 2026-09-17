# Conditional probability in ecology

Teaching materials for conditional probability, the theorem of total probability, and Bayes' theorem using ecological examples.

## Open the teaching materials

- [View the slides](https://tiagoamarques.github.io/conditionalprobability/)
- [View the Shiny app](https://github.com/TiagoAMarques/conditionalprobability/blob/main/app.R) and run it locally using the instructions below

## Contents

- `ecological_conditional_probability.qmd`: Quarto Reveal.js slide source
- `ecology.scss`: slide theme
- `docs/index.html`: rendered slides for GitHub Pages
- `app.R`: interactive Shiny application
- `R/probability_helpers.R`: probability calculations used by the app
- `tests/test_helpers.R`: dependency-free numerical checks

The examples use hypothetical data and cover disease across three wetland habitats, occupancy after a species survey, and invasive-plant occurrence near trails. The final slides discuss Bayesian inference in ecology and refer to:

> Ellison, A. M. (2004). Bayesian inference in ecology. *Ecology Letters*, 7, 509–520. <https://doi.org/10.1111/j.1461-0248.2004.00603.x>

## Run the Shiny app

Install R and the `shiny` package. The app can be downloaded and launched directly from GitHub:

```r
install.packages("shiny")
shiny::runGitHub("conditionalprobability", "TiagoAMarques")
```

Alternatively, clone or download this repository and run the project from its top-level folder:

```r
install.packages("shiny")
shiny::runApp()
```

The app recalculates every downstream probability when an input changes.

## Render the slides

Install [Quarto](https://quarto.org/) and run:

```sh
quarto render
```

Quarto writes the presentation to `docs/index.html` so GitHub Pages can serve it.

## Publish on GitHub

1. Create an empty GitHub repository.
2. Commit and push the complete contents of this folder.
3. In the repository settings, open **Pages**.
4. Select **Deploy from a branch**, choose the main branch, and use `/docs` as the folder.

The slides will then be available through GitHub Pages.

GitHub Pages serves static files and cannot execute Shiny. Students can run the app locally from this repository. To provide a browser-based app, deploy `app.R`, `R/`, and `www/` to shinyapps.io or Posit Connect, then add the deployed URL to this README.

## Check the calculations

Run:

```r
source("tests/test_helpers.R")
```

The tests reproduce the default values used in the slides.

## Requirements

- R
- R package: `shiny`
- Quarto, only when rebuilding the slides

No licence is included. Add one before publication if you want to state how others may reuse or modify the materials.
