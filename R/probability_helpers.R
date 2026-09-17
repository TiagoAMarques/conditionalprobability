check_probability <- function(x, name) {
  if (length(x) != 1L || !is.finite(x) || x < 0 || x > 1) {
    stop(sprintf("%s must be a single probability between 0 and 1.", name), call. = FALSE)
  }
  x
}

wetland_probabilities <- function(habitat, disease_given_habitat) {
  if (length(habitat) != 3L || length(disease_given_habitat) != 3L) {
    stop("The wetland example requires three habitat probabilities and three disease probabilities.", call. = FALSE)
  }
  if (any(!is.finite(habitat)) || any(habitat < 0) || any(habitat > 1)) {
    stop("Habitat probabilities must lie between 0 and 1.", call. = FALSE)
  }
  if (abs(sum(habitat) - 1) > 1e-8) {
    stop("Habitat probabilities must sum to 1.", call. = FALSE)
  }
  if (any(!is.finite(disease_given_habitat)) ||
      any(disease_given_habitat < 0) || any(disease_given_habitat > 1)) {
    stop("Conditional disease probabilities must lie between 0 and 1.", call. = FALSE)
  }

  joint <- habitat * disease_given_habitat
  total_disease <- sum(joint)
  posterior_habitat <- if (total_disease > 0) joint / total_disease else rep(NA_real_, 3L)

  names(joint) <- names(posterior_habitat) <- c("forest", "marsh", "open")
  list(
    total_disease = total_disease,
    joint = joint,
    posterior_habitat = posterior_habitat
  )
}

survey_probabilities <- function(prior_occupancy, sensitivity, false_positive) {
  prior_occupancy <- check_probability(prior_occupancy, "Prior occupancy")
  sensitivity <- check_probability(sensitivity, "Sensitivity")
  false_positive <- check_probability(false_positive, "False-positive rate")

  positive <- sensitivity * prior_occupancy + false_positive * (1 - prior_occupancy)
  posterior <- if (positive > 0) sensitivity * prior_occupancy / positive else NA_real_

  list(positive = positive, posterior_occupancy = posterior)
}

trail_probabilities <- function(prior_trail, invasive_given_trail, invasive_given_elsewhere) {
  prior_trail <- check_probability(prior_trail, "Trail-side probability")
  invasive_given_trail <- check_probability(invasive_given_trail, "Trail-side occurrence")
  invasive_given_elsewhere <- check_probability(invasive_given_elsewhere, "Elsewhere occurrence")

  invasive <- invasive_given_trail * prior_trail +
    invasive_given_elsewhere * (1 - prior_trail)
  trail_given_invasive <- if (invasive > 0) {
    invasive_given_trail * prior_trail / invasive
  } else {
    NA_real_
  }

  list(invasive = invasive, trail_given_invasive = trail_given_invasive)
}
