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
  
  ## restore objects
  restoreObjects(file, envir, clean)
  
  ## restore class definitions
  restoreClassDefinitions(file, envir, clean)
  
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
