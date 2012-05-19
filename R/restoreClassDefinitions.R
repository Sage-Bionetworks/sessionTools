# TODO: Add comment
# 
# Author: furia
###############################################################################


restoreClassDefinitions <-
  function(file="session.RData", envir=.GlobalEnv, clean = TRUE, srcEnv)
{
  if(clean){
    names <- getClasses(envir)
    for(n in names)
      removeClass(n, where = envir)
  }
  
  if(missing(srcEnv)){
    srcEnv <- new.env()
    ## load the r objects
    load(file, envir = srcEnv)
  }
  
  for(c in getClasses(srcEnv))
    assign(classMetaName(c), get(classMetaName(c), envir=srcEnv), envir = envir)
  
}
