# Conditional probability in ecology

<p align="center">
  <img src="assets/conditional-probability-wetland.png" alt="An illustrated wetland with a frog, a wading bird, overlapping probability circles, and a branching probability path" width="100%">
</p>

<p align="center">
  <strong>A visual, ecology-based introduction to conditional probability, total probability, and Bayes' theorem.</strong>
</p>

## Open the teaching materials

- [View the slides](https://tiagoamarques.github.io/conditionalprobability/)
- [Open the live Shiny app](https://connect.posit.cloud/tiago-a-marques/content/01a0ae77-2bb1-467f-3315-dcafe645cab6)
- [View the Shiny app source](https://github.com/TiagoAMarques/conditionalprobability/blob/main/app.R)

## Contents

<p align="center">
  <a href="https://tiagoamarques.github.io/conditionalprobability/"><strong>Open the presentation →</strong></a>
</p>

## Welcome! 👋

If you are a student, you are in the right place. You do **not** need to know Git or GitHub to use these materials—and you can ignore the technical-looking list of files above.

Start with the **[interactive presentation](https://tiagoamarques.github.io/conditionalprobability/)**. It opens in your browser, with nothing to install. Use the arrow keys or the controls in the bottom-right corner to move through the slides.

## What will we explore?

The material uses ecological stories to make the probability ideas concrete:

| Question | Probability idea |
| --- | --- |
| How does disease risk differ among wetland habitats? | Conditional probability |
| What is the overall disease risk across the whole wetland? | The theorem of total probability |
| After a positive survey, how likely is a species to be present? | Bayes' theorem |
| Does being near a trail change the chance of finding an invasive plant? | Combining the ideas |

All datasets in the examples are hypothetical and designed for learning.

## Want to experiment with the numbers?

The interactive app lets you change probabilities and immediately see how the results respond:

### **[Open the web-based Shiny app →](https://connect.posit.cloud/tiago-a-marques/content/01a0ae77-2bb1-467f-3315-dcafe645cab6)**

It runs directly in your browser, so there is nothing to install. The options below are only for anyone who would like to run their own copy using [R](https://cran.r-project.org/) and the `shiny` package.

The app can be downloaded and launched directly from GitHub:

```r
shiny::runGitHub("conditionalprobability", "TiagoAMarques")
```

Alternatively, clone or download this repository and run the project from its top-level folder:

```r
install.packages("shiny")  # only needed the first time
shiny::runApp()
```

If you have not used R before, ask your instructor for help with this optional part. You can follow the complete presentation without running the app.

<details>
<summary><strong>Information for instructors and contributors</strong></summary>

### What's in this repository?

- `ecological_conditional_probability.qmd` — source for the Quarto/Reveal.js presentation
- `ecology.scss` — presentation theme
- `docs/index.html` — rendered presentation served by GitHub Pages
- `app.R` — interactive Shiny application
- `R/probability_helpers.R` — probability calculations used by the app
- `tests/test_helpers.R` — dependency-free numerical checks

### Render the presentation

Install [Quarto](https://quarto.org/) and run:

```sh
quarto render
```

The rendered presentation is written to `docs/index.html`.

### Check the calculations

1. Create an empty GitHub repository.
2. Commit and push the complete contents of this folder.
3. In the repository settings, open **Pages**.
4. Select **Deploy from a branch**, choose the main branch, and use `/docs` as the folder.

The slides will then be available through GitHub Pages.

GitHub Pages serves the static slides. The interactive app is deployed separately on [Posit Connect Cloud](https://connect.posit.cloud/tiago-a-marques/content/01a0ae77-2bb1-467f-3315-dcafe645cab6), and students can also run it locally from this repository.

With R installed, run:

```r
source("tests/test_helpers.R")
```

The checks reproduce the default values used in the slides.

### Publishing notes

GitHub Pages serves the static presentation from the `/docs` folder. It cannot run the Shiny app. To offer the app in a browser, deploy `app.R`, `R/`, and `www/` to a Shiny hosting service, then add its URL above.

</details>

## Further reading

The final part of the presentation connects Bayes' theorem to Bayesian inference in ecology:

> Ellison, A. M. (2004). Bayesian inference in ecology. *Ecology Letters*, 7, 509–520. <https://doi.org/10.1111/j.1461-0248.2004.00603.x>

---

Made for students learning how probability can help us reason about the natural world. 🌿
