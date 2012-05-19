## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
## 
## filename: restoreClassDefinition.R
## description: restore S4 class definitions
## author: Matthew D. Furia <matt.furia@sagebase.org>
##
## This file is part of the sessionTools R package.
##
## sessionTools is free software: provided the Funding Acknolegement
## is maintained, you can redistribute it and/or modify it under the terms of 
## the GNU LGPL, either version 3 of the License, or (at your option) any 
## later version. For details visit <http://www.gnu.org/licenses/>.
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks.
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
