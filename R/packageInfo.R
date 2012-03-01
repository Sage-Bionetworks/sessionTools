## filename: packageInfo.R
## description: Get information about the packages in the sessionInfo object
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
