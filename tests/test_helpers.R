source(file.path("R", "probability_helpers.R"))

wetland <- wetland_probabilities(
  habitat = c(0.30, 0.40, 0.30),
  disease_given_habitat = c(0.40, 0.20, 0.10)
)
stopifnot(
  isTRUE(all.equal(wetland$total_disease, 0.23)),
  isTRUE(all.equal(unname(wetland$posterior_habitat), c(12, 8, 3) / 23))
)

survey <- survey_probabilities(0.05, 0.80, 0.10)
stopifnot(
  isTRUE(all.equal(survey$positive, 0.135)),
  isTRUE(all.equal(survey$posterior_occupancy, 0.04 / 0.135))
)

trail <- trail_probabilities(0.20, 0.50, 0.10)
stopifnot(
  isTRUE(all.equal(trail$invasive, 0.18)),
  isTRUE(all.equal(trail$trail_given_invasive, 0.10 / 0.18))
)

message("All probability helper tests passed.")
