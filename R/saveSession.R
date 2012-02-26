## Save the current session
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

saveSession <- 
    function(file="session.RData", ...)
{
  assign(".sessionInfo", sessionSummary(), envir = .GlobalEnv)
  save(list = ls(.GlobalEnv, all.names = TRUE), file = file, ...)
}


