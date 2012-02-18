# Restore a session from a file
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

restoreSession <- 
    function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{
  
  ## restore objects
  restoreObjects(file, envir, clean)
  
  if(!exists(".sessionInfo", envir = envir))
    invisible(NULL)
  
  sessionInfo <- get(".sessionInfo", envir = envir)
  
  ## set the users options
  restoreOptions(sessionInfo)
  
  ## install missing packages
  restorePackages(sessionInfo)
  
  ## restore the search path
  restoreSearchPath(sessionInfo, envir = envir, clean = clean)
  
}
