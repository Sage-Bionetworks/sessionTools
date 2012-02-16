# Install any packages in the sessionInfo object that are not installed locally
# 
# Author: Matthew D. Furia
###############################################################################

restorePackages <-
		function(sessionInfo, repos=getRepos(), warn = TRUE)
{
	## extract the package info from the sessionInfo object
	packages <- packageInfo(sessionInfo)
	
	## get a list of installed packages and their versions
	installed <- installed.packages()[,3]
	
	## determing the packages that are missng
	missing <- setdiff(names(c(packages$loadedOnly, packages$otherPkgs)), names(installed)) 

	mk <- isAvailable(missing)
	if(warn && any(!mk))
		warning("Unable to install the following packages: ", paste(missing[!mk], collapse=", "))
	
	## install missing packages
	install.packages(missing[mk], repos = repos)
	
	## TODO handle package version matching
}

