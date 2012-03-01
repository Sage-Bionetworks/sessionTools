## filename: restoreSession.R
## description: Restore a session from a file.
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

restoreSession <- 
    function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{
  
  ## restore objects
  restoreObjects(file, envir, clean)
  
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
