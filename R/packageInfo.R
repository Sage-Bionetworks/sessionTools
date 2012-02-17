# Get information about the packages in the sessionInfo object
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
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
