# Test getRepos
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

.setUp <-
		function()
{
	oldRepos <- getOption("repos")
	save(file.path(tempdir(), "oldRepos.Rbin"))
}

.tearDown <-
		function()
{
	load(file.path(tempdir(), "oldRepos.Rbin"))
	options(oldRepos)
	rm(oldRepos)
	file.remove(file.path(tempdir(), "oldRepos.Rbin"))
}

unitTestGetReposCRANnotSet <-
		function()
{
	options(repos=c(CRAN="@CRAN@"))
	repos <- getRepos()
	
	checkTrue(length(repos) > 1)
	checkTrue(getOption("repos")[["CRAN"]] != "@CRAN@")
	
}

unitTestGetReposCRANSet <-
		function()
{
	options(repos=c(CRAN="aFakeUrl"))
	repos <- getRepos()
	
	checkEqual(length(repos[["CRAN"]], 1L))
	checkEqual(repos[["CRAN"]], "aFakeUrl")
	checkEqual(getOption("repos")[["CRAN"]], "aFakeUrl")
}

unitTestGetReposUserSetExtraRepos <-
		function()
{
	options(repos=c(CRAN="aFakeUrl", anotherOne="anotherFakeURL"))
	repos <- getRepos()
	
	checkEqual(length(repos[["CRAN"]], 2L))
	checkTrue(all(c("aFakeUrl", "anotherFakeURL") %in% repos[["CRAN"]]))
	checkTrue(all(c("aFakeUrl", "anotherFakeURL") %in% getOption("repos")))
	
}

