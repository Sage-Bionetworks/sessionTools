## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: saveSession.R
## description: Save the current session.
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

saveSession <- 
  function(..., list = character(), file="session.RData", version = NULL, envir = .GlobalEnv)
{  
  if(length(as.list(substitute(list(...)))[-1L]) == 0L && length(list) == 0L){
    list = ls(envir)
    classes <- NULL
    for(cc in getClasses(envir))
      classes <- c(classes, classMetaName(cc))
    list <- c(list, classes)
  }else{
    list <- unique(c(list, as.character(as.list(substitute(list(...)))[-1L])))
    
    classes <- intersect(getClasses(envir), list)
    
    indx <- which(classes %in% ls(envir, all.names = TRUE))
    if(length(indx) != 0L){
      warning(sprintf("The following class names were masked by objects in the environement and so were not saved: %s", paste(classes[indx], collapse=",")), call.= FALSE)
      classes <- classes[-indx]
    }
      
      indx <- which(list %in% classes)
      for(ii in indx)
          list[ii] <- classMetaName(list[ii]) 
  }
  assign(".sessionInfo", sessionSummary(), envir = envir)
  save(list = c(list, ".sessionInfo"), file = file, version = version, envir = envir)
}


