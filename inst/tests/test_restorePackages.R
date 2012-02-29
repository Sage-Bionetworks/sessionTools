## Copyright 2012 Sage Bionetworks.
##
## Tests for restoring packages
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

.setUp <-
  function()
{ 
  
  .deployPackage <-
    function(pkg, repo)
  {
    ## get the fully qualified path to the package dir
    ## will throw an error if the pkgDir does not exist
    pkg <- normalizePath(pkg)
    
    if(!all(file.exists(pkg)))
      stop("Not all packages exist")
    
    ## generate the deploy directory
    contriburl <- contrib.url(repo)
    
    ## create the deploy directory
    dir.create(contriburl, recursive = TRUE, showWarnings = FALSE)
    
    type <- switch(.Platform$pkgType,
      mac.binary.leopard = "mac.binary",
      .Platform$pkgType
    )
    
    ext <- switch(type,
      mac.binary = "tgz",
      win.binary = "zip",
      "tar.gz"
    )
    
    pkg <- gsub("tar.gz$", ext, pkg)
    
    ## move the packages into place
    file.copy(pkg, contriburl)
    
    ## register the deployed package
    tools::write_PACKAGES(contriburl, type = type)
  }
  
  ## set up the local repository
  repo <- tempfile()
  dir.create(repo, recursive=TRUE)
  repo <- normalizePath(repo)
  .deployPackage(system.file("testData/helloWorld_1.0.tar.gz", package="sessionTools"), repo)
  repo <- sprintf("file://%s", repo)
  save(repo, file= file.path(tempdir(), "repo.rbin"))
  if('helloWorld' %in% installed.packages()[,1])
    stop("package 'helloWorld' already installed. please remove this package before running tests")
  
  ## set up a temporary library directory
  lib <- tempfile()
  dir.create(lib, recursive = TRUE)
  lib <- normalizePath(lib)
  save(lib, file = file.path(tempdir(), "lib.rbin"))
  .libPaths(lib)
  
  ## install helloWorld so we can get sessionInfo
  install.packages('helloWorld', repos = repo, lib = lib)
  checkTrue('helloWorld' %in% installed.packages(lib.loc=lib)[,1])
  
  library('helloWorld')
  
  ## get the sessionInfo object that will be restored
  info <- sessionInfo()
  save(info, file = file.path(tempdir(), "info.rbin"))
  
  ## unload helloWorld and uninstall it
  unloadNamespace("helloWorld")
  checkTrue(!('helloWorld' %in% loadedNamespaces()))
  remove.packages("helloWorld", lib = lib)
  checkTrue(!('helloWorld' %in% installed.packages()[,1]))
}

.tearDown <-
  function()
{
  ## unload the package if it's still attached
  if('helloWorld' %in% loadedNamespaces())
    unloadNamespace('helloWorld')
  
  ## put back the libPaths
  load(file= file.path(tempdir(), "lib.rbin"))
  .libPaths(setdiff(.libPaths(), lib))
  unlink(lib, recursive = TRUE, force = TRUE)
  
  ## clean up the local repo
  load(file= file.path(tempdir(), "repo.rbin"))
  unlink(repo, recursive = TRUE, force = TRUE)
  
  ## uninstall helloWorld if it's still attached/installed
  if('helloWorld' %in% installed.packages()[,1])
    suppressWarnings(remove.packages('helloWorld'))
}

integrationTestMissingPackage <-
  function()
{
  load(file.path(tempdir(), "info.rbin"))
  
  ## restore the packages
  load(file= file.path(tempdir(), "repo.rbin"))
  restorePackages(info, repos=repo)
  checkTrue('helloWorld' %in% installed.packages()[,1])
  checkTrue(!('helloWorld' %in% loadedNamespaces()))
  
}

integrationTestMissingPackageNotAvailable <-
  function()
{
  load(file.path(tempdir(), "info.rbin"))
   
  out <- tryCatch(restorePackages(info), warning=function(w) {return(w)}, error = function(e){stop(e)})
  checkTrue('warning' %in% class(out))
  ## checkTrue(grepl("Unable to install the following packages: helloWorld", as.character(out)))
  
}

integrationTestNoMissingPackages <-
  function()
{
  info <- sessionInfo()
  restorePackages(info)
}

integrationTestSinglePackageAvail <-
  function()
{
  load(file= file.path(tempdir(), "repo.rbin"))
  checkTrue(isPkgAvailable('helloWorld',repos = repo))
}

integrationTestAttachPackageNotAvailable <-
  function()
{
  ## install hello world
  load(file= file.path(tempdir(), "repo.rbin"))
  load(file.path(tempdir(), "lib.rbin"))
  .libPaths(lib)
  
  ## install helloWorld so we can get sessionInfo
  install.packages('helloWorld', repos = repo, lib = lib)
  library('helloWorld')
  
  info <- sessionSummary()
  unloadNamespace('helloWorld')
  remove.packages('helloWorld', lib = lib)
  checkTrue(!('helloWorld' %in% installed.packages()[,1]))
  ans <- restoreSearchPath(info)
  checkEquals(ans, character())
  checkTrue(!('helloWorld' %in% installed.packages()[,1]))
}



