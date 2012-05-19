## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: restoreS4Methods.R
## description: restore S4 Methods.
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

restoreS4Methods <-
  function(file="session.RData", envir=.GlobalEnv, clean = TRUE, srcEnv)
{
  if(clean){
    ans <- getGenerics(where = envir)
    if(length(ans@.Data) > 0L){
      for(i in 1:length(ans@.Data)){
        setPackageName(ans@package[i], envir)
        g <- ans@.Data[i]
        for(ss in names(findMethods(g, where=envir)))
          removeMethod(g, ss, where = envir)
        removeGeneric(g, where=envir)
        rm(".packageName", envir=envir)
      }
    }
  }
  
  if(missing(srcEnv)){
    srcEnv <- new.env()
    ## load the r objects
    load(file, envir = srcEnv)
  }
  
  ## restore generics first
  ans <- getGenerics(where = srcEnv)
  for(g in ans@.Data){
    gg <- getGeneric(g, where = srcEnv)
    setPackageName(attr(gg, "package"), env=envir)
    setGeneric(as.character(gg@generic), where=envir, package=gg@package, group=gg@group, def=gg@.Data, signature=gg@signature, valueClass=gg@valueClass, useAsDefault=gg@default)
    rm(".packageName", envir=envir)
  }
  
  ans <- getGenerics(where = srcEnv)
  if(length(ans@.Data) > 0L){
    for(i in 1:length(ans@.Data)){
      setPackageName(ans@package[i], envir)
      g <- ans@.Data[i]
      for(ss in names(findMethods(g, where=srcEnv))){
        mm <- getMethod(g, ss, where = srcEnv)
        setMethod(f = as.character(mm@generic), signature = mm@target, definition = mm@.Data, where = envir)
      }
      rm(".packageName", envir=envir)
    }
  }
}


