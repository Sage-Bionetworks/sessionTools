# Restore session objects
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

restoreObjects <-
		function(file="session.RData", envir=.GlobalEnv, clean = TRUE)
{
	if(clean){
		names <- ls(all.names=TRUE, envir = envir)
		if(length(names) > 0)
			rm(list = names, envir = envir)
	}
	
	## load the r objects
	load(file, envir = envir)
}