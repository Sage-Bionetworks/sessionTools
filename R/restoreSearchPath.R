# Restore the user's search path
# 
# Author: Matthew D. Furia
###############################################################################

restoreSearchPath <-
		function(sessionInfo, envir=.GlobalEnv, clean = TRUE)
{
	if(is.null(sessionInfo$search))
		invisible(NULL)
	## load packages and restore searchPath order
	indx <- grep("^package:", sessionInfo$search)
	lapply(indx, function(ii){
				name <- sessionInfo$search[[ii]]
				if(name %in% search()){
					if(ii == which(search() == name))
						return(NULL)
					detach(name, character.only = TRUE)
				}
				pkgName <- gsub("^package:", "", name)
				
				## refer to base::library directly so it will work when
				## the base package is detached
				base::library(pkgName, pos = ii, character.only = TRUE)
			}
	)
	
	## look for non-package objects that should be attached
	indx <- grep("^[^package:]", sessionInfo$search)
	lapply(indx, function(ii){
				## attach non-package objects. look for them in envir
				## note that it is possible that the object is attached under
				## a different name than it is stored in the environment
				name <- sessionInfo$search[[ii]]
				obj <- sessionInfo$searchpaths[[ii]]
				if(name %in% search()){
					detach(name, character.only = TRUE)
				}
				attach(get(obj, envir=envir), pos = ii, name=name, character.only = TRUE)
			}
	)
	
	if(clean){
		## detach objects that shouldn't be attached
		indx <- which(!(search %in% info$search))
		if(length(indx) > 0){
			lapply(indx, function(ii){
						name <- info$search[[ii]]
						detach(name, character.only = TRUE)
					}
			)
		}
	}
	invisible(NULL)
}