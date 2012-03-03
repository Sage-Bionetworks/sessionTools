## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: packageInfo.R
## description: Get information about the packages in the sessionInfo object
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


packageInfo <- function(sessionInfo = sessionInfo()){
  pkgs <- list()
  
  ## get the packages that are loaded via namespace
  pkgs$loadedOnly <- sapply(names(sessionInfo$loadedOnly), function(pkg){
        sessionInfo$loadedOnly[[pkg]]$Version
      }
  )
  
  ## packages that are attached
  pkgs$otherPkgs <- sapply(names(sessionInfo$otherPkgs), function(pkg){
        sessionInfo$otherPkgs[[pkg]]$Version
      }
  )
  
  pkgs
}
