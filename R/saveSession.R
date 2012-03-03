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
  assign(".sessionInfo", sessionSummary(), envir = envir)
  save(..., list = c(list, ".sessionInfo"), file = file, version = version, envir = envir)
}


