################################################################################
# functions to set initial values and take information from r_state
# when available
################################################################################

## from Joe Cheng's https://github.com/jcheng5/shiny-resume/blob/master/session.R
isolate({
  params <- parseQueryString(session$clientData$url_search)
  prevSSUID <- params[["SSUID"]]
})

## set the session id
if (is.null(prevSSUID)) {
  r_ssuid <- shiny:::createUniqueId(6)
} else {
  r_ssuid <- prevSSUID
}

## (re)start the session and push the id into the url
session$sendCustomMessage("session_start", r_ssuid)

## load previous state if available
if (!is.null(r_sessions[[r_ssuid]]$r_state)) {
  ## use global if available
  r_quiz    <- do.call(reactiveValues, r_sessions[[r_ssuid]]$r_quiz)
  r_answers <- do.call(reactiveValues, r_sessions[[r_ssuid]]$r_answers)
  r_hints   <- do.call(reactiveValues, r_sessions[[r_ssuid]]$r_hints)
  r_state   <- r_sessions[[r_ssuid]]$r_state
} else if (file.exists(paste0("~/r_sessions/r_", r_ssuid, ".rds"))) {
  ## read from file if not in global
  rs <- readRDS(paste0("~/r_sessions/r_", r_ssuid, ".rds"))
  r_quiz    <- do.call(reactiveValues, rs$r_quiz)
  r_answers <- do.call(reactiveValues, rs$r_answers)
  r_hints   <- do.call(reactiveValues, rs$r_hints)
  r_state   <- rs$r_state
  rm(rs)
} else {
  r_quiz    <- reactiveValues()   ## move to global when done
  r_answers <- reactiveValues()   ## keep local for store as in radiant
  r_hints   <- reactiveValues()   ## keep local for store as in radiant
  r_state   <- list()
}

################################################################################
# function to save app state on refresh or crash
################################################################################
saveStateOnRefresh <- function(session = session) {
  session$onSessionEnded(function() {
    isolate({
      r_sessions[[r_ssuid]] <- list(
        r_quiz    = reactiveValuesToList(r_quiz),
        r_answers = reactiveValuesToList(r_answers),
        r_hints   = reactiveValuesToList(r_hints),
        r_state   = reactiveValuesToList(input),
        timestamp = Sys.time()
      )
      ## saving session information to file
      saveRDS(r_sessions[[r_ssuid]], file = paste0("~/r_sessions/r_", r_ssuid, ".rds"))
    })
  })
}

state_init <- function(inputvar, init = "")
  r_state %>% { if (is.null(.[[inputvar]])) init else .[[inputvar]] }

state_single <- function(inputvar, vals, init = character(0))
  r_state %>% { if (is.null(.[[inputvar]])) init else vals[vals == .[[inputvar]]] }

state_multiple <- function(inputvar, vals, init = character(0)) {
  r_state %>%
    { if (is.null(.[[inputvar]]))
        vals[vals %in% init]
      else
        vals[vals %in% .[[inputvar]]]
    }
}
