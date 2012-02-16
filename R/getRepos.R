# Get the list of repositories to search for available R packages
# 
# Author: Matthew D. Furia
###############################################################################

getRepos <- 
		function()
{	
	## get the bioconductor repos
	repos <- tryCatch(
			BiocInstaller::biocinstallRepos(),
			error = function(e){
				local({
					source("http://bioconductor.org/biocLite.R")
				})
				
				repos <- BiocInstaller::biocinstallRepos()
				remove.packages("BiocInstaller")
				repos
			}
	)
	
	## add the users repo options	
	nms <- setdiff(names(getOption('repos')), names(repos))
	if(length(nms) > 0)
		repos <- c(repos, getOption('repos')[nms])
	
	## add the sagebionetworks repo
	rVersion <- paste(R.Version()$major, as.integer(R.Version()$minor), sep=".")
	sageRepos <- paste("http://sage.fhcrc.org/CRAN/prod", rVersion, sep="/")
	repos <- c(repos, SageBio=sageRepos)
	
}
