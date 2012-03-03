## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: getRepos.R
## description: Get the list of repositories to search for available R 
## packages
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
