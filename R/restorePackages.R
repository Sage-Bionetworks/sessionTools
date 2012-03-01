## filename: restorePackages.R
## description: Install any packages in the sessionInfo object that are not 
## installed locally
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks <www.sagebase.org>.
##
## Copyright (C) 2012  Matthew D. Furia <matt.furia@sagebase.org>
## This program is free software: providing the above funding acknolegement is
## maintained, you may redistribute and/or modify it under the terms of the 
## GNU General Public License as published by the Free Software Foundation, 
## either version 3 of the License, or (at your option) any later version.
##  
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details <http://www.gnu.org/licenses/>.
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

