## Copyright 2012 Sage Bionetworks.
##
## Restore the user's search path
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
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