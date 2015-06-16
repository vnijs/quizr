shinyUI(
  navbarPage("Bootcamp", windowTitle = "Rady", id = "nav_bootcamp",
             inverse = TRUE, collapsible = TRUE, theme = shinytheme("cerulean"),

    tabPanel("Introduction", withMathJax(), includeMarkdown("./cases/introduction.md")),

    ## cases list defined in global.R
    navbarMenu("Cases",
      tabPanel(cases[[1]], uiOutput("mini_case_1"))
    ),

    tabPanel("Your answers", htmlOutput("your_score"),
             dataTableOutput("your_answers")),

    tags$head(
      tags$script(src = "js/session.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    )
  )
)
