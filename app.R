library(shiny)

source(file.path("R", "probability_helpers.R"))

pct <- function(x, digits = 1) {
  ifelse(is.na(x), "undefined", paste0(formatC(100 * x, digits = digits, format = "f"), "%"))
}

probability_input <- function(id, label, value) {
  sliderInput(id, label, min = 0, max = 1, value = value, step = 0.01)
}

result_box <- function(title, output_id, colour = "green") {
  div(class = paste("result-box", colour),
      span(class = "result-label", title),
      textOutput(output_id, inline = TRUE))
}

ui <- navbarPage(
  title = "Ecological probability lab",
  id = "example",
  header = tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
    )
  ),

  tabPanel(
    "Wetland disease",
    div(class = "page-wrap",
      h1("Disease across three habitats"),
      p(class = "lead", "Change the habitat composition and disease probability within each habitat."),
      fluidRow(
        column(4,
          div(class = "input-panel",
            h2("Habitat probabilities"),
            probability_input("p_forest", "P(F): forest", 0.30),
            probability_input("p_marsh", "P(M): marsh", 0.40),
            div(class = "computed-input",
                span("P(O): open"), strong(textOutput("p_open", inline = TRUE))),
            p(class = "input-note", "Open habitat is the probability remaining after forest and marsh."),
            h2("Disease within habitat"),
            probability_input("d_forest", "P(D | F)", 0.40),
            probability_input("d_marsh", "P(D | M)", 0.20),
            probability_input("d_open", "P(D | O)", 0.10)
          )
        ),
        column(8,
          uiOutput("wetland_warning"),
          div(class = "results-grid",
            result_box("Overall disease P(D)", "total_disease"),
            result_box("Forest given disease P(F | D)", "forest_posterior", "rust"),
            result_box("Marsh given disease P(M | D)", "marsh_posterior", "gold"),
            result_box("Open given disease P(O | D)", "open_posterior", "blue")
          ),
          div(class = "equation-panel",
            h2("Theorem of total probability"),
            withMathJax("$$P(D)=P(D|F)P(F)+P(D|M)P(M)+P(D|O)P(O)$$"),
            uiOutput("wetland_calculation")
          ),
          div(class = "table-panel", tableOutput("wetland_table"))
        )
      )
    )
  ),

  tabPanel(
    "Species survey",
    div(class = "page-wrap",
      h1("Updating occupancy after a positive survey"),
      p(class = "lead", "Explore how prevalence, sensitivity, and false positives affect the posterior probability of occupancy."),
      fluidRow(
        column(4,
          div(class = "input-panel",
            probability_input("prior_species", "Prior occupancy P(S)", 0.05),
            probability_input("sensitivity", "Sensitivity P(+ | S)", 0.80),
            probability_input("false_positive", "False-positive rate P(+ | Sᶜ)", 0.10)
          )
        ),
        column(8,
          div(class = "results-grid two-results",
            result_box("Positive survey P(+)", "positive_survey"),
            result_box("Occupancy after +, P(S | +)", "species_posterior", "rust")
          ),
          div(class = "equation-panel",
            h2("Bayes' theorem"),
            withMathJax("$$P(S|+)=\\frac{P(+|S)P(S)}{P(+|S)P(S)+P(+|S^c)P(S^c)}$$"),
            uiOutput("survey_calculation")
          ),
          uiOutput("survey_interpretation")
        )
      )
    )
  ),

  tabPanel(
    "Invasive plant",
    div(class = "page-wrap",
      h1("Invasive plants and trail proximity"),
      p(class = "lead", "Use total probability and Bayes' theorem to connect trail proximity with plant occurrence."),
      fluidRow(
        column(4,
          div(class = "input-panel",
            probability_input("prior_trail", "Trail-side quadrat P(T)", 0.20),
            probability_input("invasive_trail", "Plant occurrence P(I | T)", 0.50),
            probability_input("invasive_elsewhere", "Plant occurrence P(I | Tᶜ)", 0.10)
          )
        ),
        column(8,
          div(class = "results-grid two-results",
            result_box("Overall occurrence P(I)", "invasive_total"),
            result_box("Trail-side given plant P(T | I)", "trail_posterior", "rust")
          ),
          div(class = "equation-panel",
            h2("Total probability, then Bayes"),
            withMathJax("$$P(I)=P(I|T)P(T)+P(I|T^c)P(T^c)$$"),
            uiOutput("trail_total_calculation"),
            withMathJax("$$P(T|I)=\\frac{P(I|T)P(T)}{P(I)}$$"),
            uiOutput("trail_bayes_calculation")
          )
        )
      )
    )
  ),

  tabPanel(
    "About",
    div(class = "page-wrap narrow",
      h1("About this app"),
      p("This app accompanies the Quarto deck ",
        tags$strong("Conditional probability in ecology"),
        ", available in the repository at ", tags$code("docs/index.html"), "."),
      p("It illustrates conditional probability, the theorem of total probability, and Bayes' theorem with hypothetical ecological data."),
      h2("Notation"),
      tags$ul(
        tags$li("F, M, O: forest, marsh, and open habitats"),
        tags$li("D: disease detected"),
        tags$li("S: the species occupies the surveyed site"),
        tags$li("+: the survey returns a positive result"),
        tags$li("T: the quadrat lies beside a trail"),
        tags$li("I: the invasive plant occurs")
      ),
      p(class = "input-note", "All examples use hypothetical data for teaching.")
    )
  )
)

server <- function(input, output, session) {
  open_habitat <- reactive(1 - input$p_forest - input$p_marsh)

  output$p_open <- renderText(pct(open_habitat()))

  wetland <- reactive({
    req(open_habitat() >= 0)
    wetland_probabilities(
      habitat = c(input$p_forest, input$p_marsh, open_habitat()),
      disease_given_habitat = c(input$d_forest, input$d_marsh, input$d_open)
    )
  })

  output$wetland_warning <- renderUI({
    if (open_habitat() < 0) {
      div(class = "warning-box",
          "Forest and marsh probabilities sum to more than 1. Reduce one of them to leave a non-negative open-habitat probability.")
    }
  })

  output$total_disease <- renderText(pct(wetland()$total_disease))
  output$forest_posterior <- renderText(pct(wetland()$posterior_habitat[["forest"]]))
  output$marsh_posterior <- renderText(pct(wetland()$posterior_habitat[["marsh"]]))
  output$open_posterior <- renderText(pct(wetland()$posterior_habitat[["open"]]))

  output$wetland_calculation <- renderUI({
    w <- wetland()
    HTML(sprintf(
      "<div class='numeric-equation'>P(D) = (%.2f)(%.2f) + (%.2f)(%.2f) + (%.2f)(%.2f) = %.3f</div>",
      input$d_forest, input$p_forest,
      input$d_marsh, input$p_marsh,
      input$d_open, open_habitat(),
      w$total_disease
    ))
  })

  output$wetland_table <- renderTable({
    w <- wetland()
    data.frame(
      Habitat = c("Forest", "Marsh", "Open"),
      `P(habitat)` = c(input$p_forest, input$p_marsh, open_habitat()),
      `P(D | habitat)` = c(input$d_forest, input$d_marsh, input$d_open),
      `P(D and habitat)` = unname(w$joint),
      `P(habitat | D)` = unname(w$posterior_habitat),
      check.names = FALSE
    )
  }, digits = 3, striped = TRUE, bordered = FALSE, spacing = "s")

  survey <- reactive({
    survey_probabilities(input$prior_species, input$sensitivity, input$false_positive)
  })

  output$positive_survey <- renderText(pct(survey()$positive))
  output$species_posterior <- renderText(pct(survey()$posterior_occupancy))
  output$survey_calculation <- renderUI({
    x <- survey()
    HTML(sprintf(
      "<div class='numeric-equation'>P(S | +) = [(%.2f)(%.2f)] / [(%.2f)(%.2f) + (%.2f)(%.2f)] = %.3f</div>",
      input$sensitivity, input$prior_species,
      input$sensitivity, input$prior_species,
      input$false_positive, 1 - input$prior_species,
      x$posterior_occupancy
    ))
  })
  output$survey_interpretation <- renderUI({
    div(class = "interpretation",
        sprintf("A positive survey changes estimated occupancy from %s to %s.",
                pct(input$prior_species), pct(survey()$posterior_occupancy)))
  })

  trail <- reactive({
    trail_probabilities(input$prior_trail, input$invasive_trail, input$invasive_elsewhere)
  })

  output$invasive_total <- renderText(pct(trail()$invasive))
  output$trail_posterior <- renderText(pct(trail()$trail_given_invasive))
  output$trail_total_calculation <- renderUI({
    x <- trail()
    HTML(sprintf(
      "<div class='numeric-equation'>P(I) = (%.2f)(%.2f) + (%.2f)(%.2f) = %.3f</div>",
      input$invasive_trail, input$prior_trail,
      input$invasive_elsewhere, 1 - input$prior_trail,
      x$invasive
    ))
  })
  output$trail_bayes_calculation <- renderUI({
    x <- trail()
    HTML(sprintf(
      "<div class='numeric-equation'>P(T | I) = [(%.2f)(%.2f)] / %.3f = %.3f</div>",
      input$invasive_trail, input$prior_trail,
      x$invasive, x$trail_given_invasive
    ))
  })
}

shinyApp(ui, server)
