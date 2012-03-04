## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
## 
## filename: test_getRepos.R
## description: Test getRepos method.
## author: Matthew D. Furia <matt.furia@sagebase.org>
##
## This file is part of the sessionTools R package.
##
## sessionTools is free software: provided the Funding Acknolegement
## is maintained, you can redistribute it and/or modify it under the terms of 
## the GNU LGPL, either version 3 of the License, or (at your option) any 
## later version. For details visit <http://www.gnu.org/licenses/>.
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks.
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

## THIS TEST BREAKS ON CRAN TEST SERVERS. I haven't been able to 
## find documentation of their build system so am unable to re-create the
## failure. I will re-enable the test once I can simulate their
##unitTestGetReposCRANnotSet <-
##    function()
##{
##  options(repos=c(CRAN="@CRAN@"))
##  repos <- getRepos()
##  
##  checkTrue(length(repos) > 1)
##  checkTrue(repos[["CRAN"]] != "@CRAN@")
##  checkEquals(getOption("repos")[["CRAN"]], "@CRAN@")
##}

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