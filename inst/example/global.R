## loading / installing dependencies as needed
dep <- c("shiny", "ggplot2", "rmarkdown", "dplyr", "knitr", "tidyr", "grid", "shinythemes")

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

## functions for rendering (r)markdown and modals
source("./bootcamp.R")

## environment to hold session information
r_sessions <- new.env(parent = emptyenv())

## create directory to hold session files
"~/r_sessions/" %>% {if (!file.exists(.)) dir.create(., recursive = TRUE)}

## case names
cases <- list("1" = "1. Demand and Cost",
              "2" = "2. Investment",
              "3" = "3. Consumer Consumption",
              "4" = "4. Service Operations",
              "5" = "5. Data Analytics")
