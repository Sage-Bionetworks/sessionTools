# TODO: Add comment
# 
# Author: furia
###############################################################################


restoreClassDefinitions <-
  function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{
  if(clean){
    names <- getClasses(envir)
    for(n in names)
      removeClass(n, where = envir)
  }
  
  tmpenv <- new.env()
  
  ## load the r objects
  load(file, envir = tmpenv)
  
  metaNames <- NULL
  for(c in getClasses(tmpenv))
    metaNames <- c(metaNames, classMetaName(c))
  
  rm(list=setdiff(objects(tmpenv, all.names=TRUE), metaNames), envir=tmpenv)
  
  ans <- lapply(objects(tmpenv, all.names=TRUE), function(o) assign(o, get(o, envir=tmpenv) , envir=envir))
}
