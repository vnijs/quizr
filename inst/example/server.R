shinyServer(function(input, output, session) {

  ## set the table for the quiz questions
  source("./init.R", local = TRUE)

  ## locating the environment used by shiny
  ## r_quiz is a reactiveValues object defined in init.R
  r_env <- pryr::where("r_quiz")

  ## set the table for the quiz questions
  source("./quiz.R", local = TRUE)

  ## get content for each of the mini cases
  source("./cases/case1/mini_case_1.R", local = TRUE)

  ## save state on refresh or browser close
  saveStateOnRefresh(session)
})
