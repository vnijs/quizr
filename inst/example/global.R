## loading / installing dependencies as needed
dep <- c("shiny", "ggplot2", "dplyr", "knitr", "tidyr", "grid", "shinythemes", "pryr")

for (d in dep) {
  if (!require(d, character.only = TRUE)) {
    install.packages(d, repos = "http://cran.rstudio.com/")
    library(d, character.only = TRUE)
  }
}

## using local mathjax if available
if ("MathJaxR" %in% installed.packages()[,"Package"]) {
  addResourcePath("MathJax", file.path(system.file(package = "MathJaxR"), "MathJax/"))
  withMathJax <- MathJaxR::withMathJaxR
}

## installing DT if not yet available
if (!"DT" %in% installed.packages()[,"Package"])
	install.packages("DT", repos = "http://vnijs.github.io/radiant_miniCRAN/")

## using DT rather than Shiny versions of datatable
renderDataTable <- DT::renderDataTable
dataTableOutput <- DT::dataTableOutput
datatable       <- DT::datatable

## path to images and js
addResourcePath("images", "www/images/")
addResourcePath("js", "www/js/")

## options for knitting/rendering rmarkdown chunks
knitr::opts_chunk$set(echo = FALSE, comment = NA, cache = FALSE,
                      message = FALSE, warning = FALSE)

## environment to hold session information
r_sessions <- new.env(parent = emptyenv())

## create directory to hold session files
"~/r_sessions/" %>% {if (!file.exists(.)) dir.create(., recursive = TRUE)}

## case names
cases <- list("1" = "1. Demand and Cost")

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
inclRmd <- function(path, r_env) {
  paste(readLines(path, warn = FALSE), collapse = '\n') %>%
  knitr::knit2html(text = ., fragment.only = TRUE, quiet = TRUE, envir = r_env,
                   options = "", stylesheet = "../www/empty.css") %>%
    gsub("&lt;!--/html_preserve--&gt;","",.) %>%  ## knitr adds this
    gsub("&lt;!--html_preserve--&gt;","",.) %>%   ## knitr adds this
    HTML %>%
    withMathJax
}

## check if a button WAS pressed
is_empty <- function(x, empty = "") if (is.null(x) || x == empty) TRUE else FALSE
