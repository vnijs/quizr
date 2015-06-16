## generate quiz questions
quiz_question <- function(question = "", q_nr = 1) {
  paste0("<p>Question ",q_nr,": ", question,"<p>") %>% HTML %>% withMathJax
}

quiz_mc <- function(answers = "", q_nr, inline = TRUE) {
  output[[paste0("ui_quiz_mc",q_nr)]] <- renderUI({
    input_name <- paste0("quiz_mc",q_nr)
    ## use current value rather than state if available
    sel <- if (is_empty(input[[input_name]])) state_init(input_name) else input[[input_name]]
    radioButtons(input_name, NULL, answers, selected = sel,
                 inline = inline) %>% withMathJax
  })
}

quiz_buttons <- function(q_nr) {
  tagList(
    with(tags,
      table(
        td(button(id = paste0("quiz_submit",q_nr), type = "button",
                  class = "btn btn-info action-button shiny-bound-input",
                  "Submit")),
        td(HTML("&nbsp;&nbsp;")),
        td(button(id = paste0("quiz_hint",q_nr), type = "button",
                  class = "btn btn-primary action-button shiny-bound-input",
                  "Hint"))
      )
    )
  )
}

quiz_out <- function(q_nr, color, feedback, correct, answer) {

  if(is_empty(r_answers[[paste0("quiz_",q_nr)]])) {
    hint_used <- if (is_empty(r_hints[[paste0("quiz_",q_nr)]])) "no" else "yes"
    score <- if (feedback == "correct") 5 else 0
    score <- if (hint_used == "yes") score - 1  else score
    r_answers[[paste0("quiz_",q_nr)]] <- c(cases[[substr(q_nr,1,1)]], q_nr,
                                           input[[paste0("quiz_mc",q_nr)]],
                                           hint_used, score, 5)
  }

  ## slightly nicer feedback, could randomize
  rsp <- if (feedback == "correct") "You got it!" else "Missed that one"

  paste0("<br /><ul><li><b><font color=", color, ">", rsp, "</font></b>
         </li><li>Answer: ", correct, "</li><li>Explanation: ", answer, "</li></ul>")
}

quiz_observe <- function(q_nr, correct, answer, hint) {
  r_quiz[[paste0("quiz_",q_nr)]] <- ""

  observe({
    input[[paste0("quiz_mc",q_nr)]]
    isolate({
      r_quiz[[paste0("quiz_",q_nr)]] <- ""
    })
  })

  observeEvent(input[[paste0("quiz_hint",q_nr)]], {
    isolate({
      r_quiz[[paste0("quiz_",q_nr)]]  <- paste0("<br />Hint: ", hint)
      if(is_empty(r_answers[[paste0("quiz_",q_nr)]]))
        r_hints[[paste0("quiz_",q_nr)]] <- "used"

    })
  })

  observeEvent(input[[paste0("quiz_submit",q_nr)]], {
    isolate({
      r_quiz[[paste0("quiz_",q_nr)]]  <-
      { if (is_empty(input[[paste0("quiz_mc",q_nr)]])) {
          "<br />Choose an option and press Submit"
        } else if (input[[paste0("quiz_mc",q_nr)]] == correct) {
          quiz_out(q_nr, "green", "correct", correct, answer)
        } else {
          quiz_out(q_nr, "red", "incorrect", correct, answer)
        }
      }
    })
  })
  return(invisible())
}

make_quiz <- function(q_nr, question, mc, correct, answer, hint, inline = TRUE) {
  quiz_observe(q_nr, correct, answer, hint)
  quiz_mc(mc, q_nr, inline = inline)

  output[[paste0("quiz_",q_nr)]] <- renderUI({
    tagList(
      HTML("<div style='background-color:rgba(178, 204, 255, .1); padding:20px 20px; margin-top:10px; width:100%; border:1px solid black'>"),
      quiz_question(question, q_nr),
      uiOutput(paste0("ui_quiz_mc",q_nr)),
      quiz_buttons(q_nr),
      HTML(r_quiz[[paste0("quiz_",q_nr)]]) %>% withMathJax,
      HTML("</div>"),
      tags$br()
    )
  })
}

answer_table <- reactive({
  tab <- reactiveValuesToList(r_answers)
  if (length(tab) == 0) return(NULL)
  tab <- data.frame(tab, stringsAsFactors = FALSE) %>% t %>%
    data.frame(stringsAsFactors = FALSE)
  colnames(tab) <- c("Case", "Question", "Selected", "Hint", "Score", "Max")
  tab$Case <- as.factor(tab$Case)
  tab$Hint <- as.factor(tab$Hint)
  tab$Score <- as.integer(tab$Score)
  tab$Max <- as.integer(tab$Max)
  tab
})

output$your_score <- renderPrint({
  tab <- answer_table()
  if (is.null(tab)) {
    cat("<h3>Nothing yet. Go answer some quiz questions!</h3>")
    return(invisible())
  } else {
    ret <- summarize(tab, score = sum(Score), total = sum(Max), perc = round(100 * score/total,1))
    cat(with(ret, paste0("<h3>Your quiz answers &mdash; Score ", perc, "% (", score, "/", total, ")</h3>")))
  }
})

output$your_answers <- renderDataTable({

  tab <- answer_table()
  if (is.null(tab)) return()

  datatable(tab, filter = list(position = "top", clear = FALSE, plain = TRUE),
    rownames = FALSE, style = "bootstrap", escape = TRUE,
    options = list(
      search = list(regex = TRUE),
      autoWidth = TRUE,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      processing = FALSE,
      pageLength = 10,
      lengthMenu = list(c(10, 25, 50, -1), c("10", "25", "50", "All"))
    )
  )
})
