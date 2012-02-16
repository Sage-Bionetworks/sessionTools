restoreSession <- 
		function(file="session.RData", envir=.GlobalEnv, clean = TRUE, ...)
{
		
	if(clean){
		names <- ls(all.names=TRUE, envir = envir)
		if(length(names) > 0)
			rm(list = names, envir = envir)
	}
	
	## load the r objects
	load(file, envir = envir)
	
	if(!exists(".sessionInfo", envir = envir))
		invisible(NULL)
	
	## set the users options
	restoreOptions(.sessionInfo)
	
	## install missing packages
	restorePackages(.sessionInfo)
	
	## restore the search path
	restoreSearchPath(.sessionInfo, envir = envir, clean = clean)
	
}
