# Unit tests for restoring R options
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
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
