## filename: restoreSearchPath.R
## description: Restore the user's search path.
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

restoreSearchPath <-
  function(sessionInfo, envir=.GlobalEnv, clean = TRUE)
{
  if(is.null(sessionInfo$search))
    invisible(NULL)
  detached <- character()
  if(clean){
    ## detach objects that shouldn't be attached
    ## can't attach at position 1 so exclude it
    indx <- which(!(search() %in% sessionInfo$search))
    indx <- setdiff(indx, 1L)
    if(length(indx) > 0){ 
      detached <- sapply(indx, function(ii){
          name <- search()[ii]
          detach(ii, character.only = TRUE)
          name
        }
      )
    }
  }else{
    ## insert added objects into search list
    for(n in setdiff(search(), sessionInfo$search)){
      ii <- which(search() == n)
      sessionInfo <- list(search = c(sessionInfo$search[1:(ii - 1)], search()[ii], sessionInfo$search[ii:length(sessionInfo$search)]))
    }
  }
  detached <- as.character(detached)
  
  ## reattach objects to the search path
  attached <- character()
  indx <- which(!(sessionInfo$search %in% search()))
  attached <- sapply(indx, function(ii){
      name <- sessionInfo$search[ii]
      obj <- sessionInfo$searchpaths[ii]
      if(grepl("^package:", name)){
        error <- FALSE
        tryCatch(
          library(gsub("^package:", "", name), pos = ii, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE),
          error = function(e){
            warning(sprintf("Unable to attach %s. Is the library installed?: %s", name, e))
            error <<- TRUE
            sessionInfo <<- list(search = sessionInfo$search[-ii])
          }
        )
        if(error)
          return(NULL)
      }else{
        error <- FALSE
        tryCatch(
          attach(get(obj, envir = envir), pos = ii, name = name, warn.conflicts = FALSE),
          error = function(e){
            warning(sprintf("Unable to attach %s. Was the object removed from the source environment?: %s", name, e))
            error <<- TRUE
            sessionInfo <<- list(search = sessionInfo$search[-ii])
          }
        )
        if(error)
          return(NULL)
      }
      name
    }
  )
  attached <- as.character(attached)
  
  ## rearrange the search order
  ## ignore the first and last positions
  ## since the are not user-modifiable
  moved <- character()
  moved <- sapply(2:(length(sessionInfo$search)-1), function(ii){
      name <- sessionInfo$search[[ii]]
      if(name %in% search()){
        if(ii == which(search() == name))
          return(NULL)        
        ## if the package is already attached
        ## just move the first instance
        tmpii <- which(search() == name)[1]
        if(grepl("^package:", name)){
          suppressWarnings(detach(pos=tmpii, force = TRUE))
          library(gsub("^package:", "", name), pos = ii, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)
        }else{
          attach(as.environment(tmpii), pos=ii, warn.conflicts = FALSE, name = name)
          if(ii < tmpii){
            suppressWarnings(detach(pos = tmpii + 1, force = TRUE))
          }else{
            suppressWarnings(detach(pos = tmpii, force = TRUE))
          }
        }
        name
      }
    }
  )
  moved <- as.character(moved)
  moved <- unique(c(moved, detached, attached))
  
  indx <- which(moved == "NULL")
  if(length(indx) > 0)
    moved <- moved[-indx]
  invisible(moved)
}