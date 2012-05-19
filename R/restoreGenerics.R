## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: restoreGenerics.R
## description: restore Generic functions.
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

restoreGenerics <-
  function(file="session.RData", envir=.GlobalEnv, clean = TRUE, srcEnv)
{
  if(clean){
    gg <- getGenerics(envir)
    for(g in gg@.Data)
      removeGeneric(g, where = envir)
  }
  
  if(missing(srcEnv)){
    srcEnv <- new.env()
    ## load the r objects
    load(file, envir = srcEnv)
  }
  
  ans <- getGenerics(where = srcEnv)
  for(g in ans@.Data){
    gg <- getGeneric(g, where = srcEnv)
    setPackageName(attr(gg, "package"), env=envir)
    setGeneric(as.character(gg@generic), where=envir, package=gg@package, group=gg@group, def=gg@.Data, signature=gg@signature, valueClass=gg@valueClass, useAsDefault=gg@default)
    rm(".packageName", envir=envir)
  }
}
