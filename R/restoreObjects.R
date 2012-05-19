## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: restoreObjects.R
## description: Restore session objects
## author: Matthew D. Furia <matt.furia@sagebase.org>
##
## This file is part of the sessionTools R package.
##
## sessionTools is free software: provided the Funding Acknolegement
## is maintained, you can redistribute it and/or modify it under the terms of 
## the GNU LGPL-3, either version 3 of the License, or (at your option) any 
## later version. For details visit <http://www.gnu.org/licenses/>.
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks.
###############################################################################

restoreObjects <-
  function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{  
  if(clean){
    names <- ls(all.names=TRUE, envir = envir)
    if(length(names) > 0)
      rm(list = names, envir = envir)
  }
  
  srcEnv <- new.env()
  ## load the r objects
  load(file, envir = srcEnv)
  
  for(c in getClasses(srcEnv))
    removeClass(c, where = srcEnv)
  
  ans <- getGenerics(where = srcEnv)
  if(length(ans@.Data) > 0L){
    for(i in 1:length(ans@.Data)){
      setPackageName(ans@package[i], srcEnv)
      g <- ans@.Data[i]
      for(ss in names(findMethods(g, where=srcEnv)))
        removeMethod(g, ss, where = srcEnv)
      rm(".packageName", envir=srcEnv)
    }
  }
  
  ans <- getGenerics(where = srcEnv)
  for(g in ans@.Data)
    removeGeneric(g, where = srcEnv)
  
  ans <- lapply(objects(srcEnv, all.names=TRUE), function(o) assign(o, get(o, envir=srcEnv) , envir=envir))
}