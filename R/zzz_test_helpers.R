# This function is used in unit testing to skip tests if the config file is missing
#
skip_if_missing_config <- function(f){
  if(!file.exists(f)) {
    msg <- paste("To run tests, add a file ~/.azuresmr/settings.json containing AzureML keys.",
                 "See ?workspace for help",
                 sep = "\n")
    message(msg)
    testthat::skip("settings.json file is missing")
  }
}

skip_if_offline <- function(){
  u <- tryCatch(url("https://mran.microsoft.com"),
                error = function(e)e)
  if(inherits(u, "error")){
    u <- url("http://mran.microsoft.com")
  }
  on.exit(close(u))
  z <- tryCatch(suppressWarnings(readLines(u, n = 1, warn = FALSE)),
                error = function(e)e)
  if(inherits(z, "error")){
    testthat::skip("Offline. Skipping test.")
  }
}

# wait until request is completed
wait_for_azure <- function(expr, pause = 3, times = 40){
  Sys.sleep(2)
  terminate <- FALSE
  .counter <- 0
  while(!terminate && .counter <= times){
    terminate <- isTRUE(eval(expr))
    if(terminate) break
    .counter <- .counter + 1
    Sys.sleep(pause)
  }
  terminate
}
