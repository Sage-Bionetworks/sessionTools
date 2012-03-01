## filename: test_getRepos.R
## description: Test getRepos method.
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks <www.sagebase.org>.
##
## Copyright (C) 2012  Matthew D. Furia <matt.furia@sagebase.org>
## This program is free software: providing the above funding acknolegement is
## maintained, you may redistribute and/or modify it under the terms of the 
## GNU General Public License as published by the Free Software Foundation, 
## either version 3 of the License, or (at your option) any later version.
##  
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details <http://www.gnu.org/licenses/>.
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