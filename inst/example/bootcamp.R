## create a bootstrap modal
bs_modal <- function(modal_title, link, file) {
  sprintf("<div class='modal fade' id='%s' tabindex='-1' role='dialog' aria-labelledby='%s_label' aria-hidden='true'> <div class='modal-dialog'> <div class='modal-content'> <div class='modal-header'> <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button> <h4 class='modal-title' id='%s_label'>%s</h4> </div> <div class='modal-body'> %s </div> </div> </div> </div> <button type='button' data-toggle='modal' data-target='#%s' class='btn btn-success' aria-label='Left Align'> <span class='glyphicon glyphicon-film' aria-hidden='true'></span> Video </button>",
    link, link, link, modal_title, file, link) %>% HTML
}

## function to render .md files to html
inclMD <- function(path) {
  markdown::markdownToHTML(path, fragment.only = TRUE, options = c(""),
                           stylesheet="../www/empty.css")
}

## function to render .Rmd files to html - does not embed image or add css
inclRmd <- function(path) {
  paste(readLines(path, warn = FALSE), collapse = '\n') %>%
  knitr::knit2html(text = ., fragment.only = TRUE, options = "",
                   stylesheet="../www/empty.css") %>%
    gsub("&lt;!--/html_preserve--&gt;","",.) %>%  ## knitr adds this
    gsub("&lt;!--html_preserve--&gt;","",.) %>%   ## knitr adds this
    HTML %>%
    withMathJax
}

## check if a button was NOT pressed
# not_pressed <- function(x) if (is.null(x) || x == 0) TRUE else FALSE

## check if a button WAS pressed
was_pressed <- function(x) if (is.null(x) || x == 0) FALSE else TRUE

## check if a button WAS pressed
is_empty <- function(x, empty = "") if (is.null(x) || x == empty) TRUE else FALSE
