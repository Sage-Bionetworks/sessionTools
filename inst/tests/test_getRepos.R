## Test getRepos
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

.setUp <-
    function()
{
  oldRepos <- getOption("repos")
  save(oldRepos, file = file.path(tempdir(), "oldRepos.Rbin"))
}

.tearDown <-
    function()
{
  load(file.path(tempdir(), "oldRepos.Rbin"))
  options(oldRepos)
  rm(oldRepos)
  unlink(file.path(tempdir(), "oldRepos.Rbin"))
}

unitTestGetReposCRANnotSet <-
    function()
{
  options(repos=c(CRAN="@CRAN@"))
  repos <- getRepos()
  
  checkTrue(length(repos) > 1)
  checkTrue(repos[["CRAN"]] != "@CRAN@")
  checkEquals(getOption("repos")[["CRAN"]], "@CRAN@")
}

unitTestGetReposCRANSet <-
    function()
{
  options(repos=c(CRAN="aFakeUrl"))
  repos <- getRepos()
  
  checkEquals(length(repos[["CRAN"]]), 1L)
  checkEquals(repos[["CRAN"]], "aFakeUrl")
  checkEquals(getOption("repos")[["CRAN"]], "aFakeUrl")
}

unitTestGetReposUserSetExtraRepos <-
    function()
{
  options(repos=c(CRAN="aFakeUrl", anotherOne="anotherFakeURL"))
  repos <- getRepos()
  
  checkTrue(all(c("CRAN", "anotherOne") %in% names(getOption("repos"))))
  checkEquals(length(repos[["CRAN"]]), 1L)
  checkEquals("aFakeUrl", repos[["CRAN"]])
  checkEquals("anotherFakeURL", repos[["anotherOne"]])	
}