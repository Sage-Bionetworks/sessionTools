## Save the current session
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

saveSession <- 
    function(..., list = character(), file="session.RData", version = NULL, envir = .GlobalEnv)
{
  assign(".sessionInfo", sessionSummary(), envir = envir)
  save(..., list = c(list, ".sessionInfo"), file = file, version = version, envir = envir)
}


