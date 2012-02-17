# Save the current session
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

saveSession <- 
		function(file="session.RData", ...)
{
        assign(".sessionInfo", describeSession(), envir = .GlobalEnv)
        save(list = ls(envir = .GlobalEnv, all.names = TRUE), file = file, ...)
}


