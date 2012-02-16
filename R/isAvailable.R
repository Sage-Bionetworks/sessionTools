# Check whether the packages are available in the repos
# 
# Author: Matthew D. Furia
###############################################################################

isAvailable <- 
		function(pkg, repos = getOption("repos"), version)
{
		apkg <- data.frame(available.packages(contriburl = contrib.url(repos)), stringsAsFactors=FALSE)
		pkg %in% apkg$Package
}
