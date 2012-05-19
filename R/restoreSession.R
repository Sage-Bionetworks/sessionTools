## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: restoreSession.R
## description: Restore a session from a file.
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

restoreSession <- 
    function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{
  srcEnv <- new.env()
  load(file, envir=srcEnv)
  
  ## restore objects
  restoreObjects(file, envir=envir, clean=clean)
  
  ## restore class definitions
  restoreClassDefinitions(srcEnv = srcEnv, envir = envir, clean = clean)
  
  ## restore S4 classes and generics
  restoreGenerics(srcEnv = srcEnv, envir = envir, clean = clean)
  restoreS4Methods(srcEnv = srcEnv, envir = envir, clean = clean)
  
  if(!exists(".sessionInfo", envir = srcEnv))
    invisible(NULL)
  
  sessionInfo <- get(".sessionInfo", envir = srcEnv)
  
  ## set the users options
  restoreOptions(sessionInfo)
  
  ## install missing packages
  restorePackages(sessionInfo)
  
  ## restore the search path
  restoreSearchPath(sessionInfo, envir = envir, clean = clean)
  
}
