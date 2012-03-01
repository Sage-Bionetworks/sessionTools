## filename: test_restoreOptions.R
## description: test restoreOptions method.
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
  oldOpts <- options()
  save(oldOpts, file=file.path(tempdir(), "oldOpts.Rbin"))
}

.tearDown <-
    function()
{
  load(file=file.path(tempdir(), "oldOpts.Rbin"))
  options(oldOpts)
  rmOpts <- setdiff(names(options()), names(oldOpts))
  opt <- list(aName=NULL)
  for(name in rmOpts){
    names(opt) <- name
    options(opt)
  }
  rm(oldOpts)
  file.remove(file.path(tempdir(), "oldOpts.Rbin"))
}

unitTestRestoreOptions <-
    function()
{
  load(file.path(tempdir(), "oldOpts.Rbin"))
  sessionInfo <- list(opts = list(repos=c(CRAN="aFakeCranRepo", SageBio="aFakeLranRepo"), 
          otherOpt="foobar", verbose=!getOption("verbose")))
  
  ## only the repos option should be set
  restoreOptions(sessionInfo)
  
  checkTrue(all(getOption("repos") == c(CRAN="aFakeCranRepo", SageBio="aFakeLranRepo")))
  checkEquals(length(options()), length(oldOpts))
  checkTrue(all(names(oldOpts) %in% names(options())))
}

unitTestRestoreOptionsMoreOpts <-
    function()
{
  load(file.path(tempdir(), "oldOpts.Rbin"))
  options(otherOpt = "aValue")
  sessionInfo <- list(opts = list(repos=c(CRAN="aFakeCranRepo", SageBio="aFakeLranRepo"), 
          otherOpt="foobar", verbose=!getOption("verbose")))
  
  ## only the repos option should be set
  restoreOptions(sessionInfo)
  
  checkTrue(all(getOption("repos") == c(CRAN="aFakeCranRepo", SageBio="aFakeLranRepo")))
  checkEquals(length(options()), length(oldOpts) + 1)
  checkTrue(all(names(oldOpts) %in% names(options())))
  
  ## make sure otherOpt has it's original value
  checkEquals(getOption("otherOpt"), "aValue")
}
