## filename: getRepos.R
## description: Get the list of repositories to search for available R 
## packages
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

getRepos <- 
  function()
{	
  ## get the bioconductor repos
  repos <- tryCatch(
    BiocInstaller::biocinstallRepos(),
    error = function(e){
      file <- file(tempfile(), open="wt")
      sink(file, type="message")
      tryCatch(
        local(source("http://bioconductor.org/biocLite.R")),
        error = function(e){
          return(getOption("repos"))
        },
        finally={
          sink()
          unlink(file)
        }
      )
      repos <- tryCatch({BiocInstaller::biocinstallRepos()
          unloadNamespace("BiocInstaller")
          remove.packages("BiocInstaller")
        },error = function(e){return(getOption("repos"))}
      )
      repos
    }
  )
  
  ## add the users repo options	
  nms <- setdiff(names(getOption('repos')), names(repos))
  if(length(nms) > 0)
    repos <- c(repos, getOption('repos')[nms])
  repos
}
