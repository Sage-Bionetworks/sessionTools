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
  
  tmpenv <- new.env()
  
  ## load the r objects
  load(file, envir = tmpenv)
  
  for(c in getClasses(tmpenv))
    removeClass(c, where = tmpenv)
  
  lapply(objects(tmpenv, all.names=TRUE), function(o) assign(o, get(o, envir=tmpenv) , envir=envir))
}