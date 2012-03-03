## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: restorePackages.R
## description: Install any packages in the sessionInfo object that are not 
## installed locally
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

restorePackages <-
    function(sessionInfo, repos=getRepos(), warn = TRUE)
{
  ## extract the package info from the sessionInfo object
  packages <- packageInfo(sessionInfo)
  
  ## get a list of installed packages and their versions
  installed <- installed.packages()[,3]
  
  ## determing the packages that are missng
  missing <- setdiff(names(c(packages$loadedOnly, packages$otherPkgs)), names(installed)) 
  
  mk <- isPkgAvailable(missing, repos = repos)
  if(warn && any(!mk))
    warning("Unable to install the following packages: ", paste(missing[!mk], collapse=", "))
  
  ## install missing packages
  if(any(mk))
    install.packages(missing[mk], repos = repos)
  
  ## TODO handle package version matching
}

