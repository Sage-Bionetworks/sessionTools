# Restore the R options
# 
# Author: Matthew D. Furia
###############################################################################

restoreOptions <-
		function(sessionInfo)
{
	## for now only restore the repos option
	## TODO determine the comprehensive list of options
	## that are not portable and exclude only those
	kOptions <- "repos"
	
	options(sessionInfo$opts[kOptions])
}


