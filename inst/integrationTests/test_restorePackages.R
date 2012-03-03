## filename: test_restorePackages.R
## description: Tests for restoring packages.
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
  
  .deployPackage <-
    function(pkg, repo)
  {
    ## get the fully qualified path to the package dir
    ## will throw an error if the pkgDir does not exist
    pkg <- normalizePath(pkg)
    
    if(!file.exists(pkg))
      stop("package directory does not exist")
    
    ## generate the deploy directory
    contriburl <- contrib.url(repo)
    
    ## create the deploy directory
    dir.create(contriburl, recursive = TRUE, showWarnings = FALSE)

    ## remove the package from the library
    ## this is necessary since devtools::build does not
    ## allow you to specify the library in which to install
    ## when executing R CMD INSTALL --build
    remove.packages("helloWorld", lib=.libPaths())
        
    ## get the package type
    type <- switch(.Platform$pkgType,
      mac.binary.leopard="mac.binary",
      .Platform$pkgType
    )
    
    ## determine where build type is binary
    binary <- switch(type,
      source = FALSE,
      TRUE
    )

    ## build the package
    devtools::build(pkg, path=contriburl, binary = binary)   
 
    ## register the deployed package
    tools::write_PACKAGES(contriburl, type=type)
  }
  
  ## make sure that helloWorld is not already installed
  if('helloWorld' %in% installed.packages()[,1])
    stop("package 'helloWorld' already installed. please remove this package before running tests")
  
  ## set up the local repository
  repo <- tempfile()
  dir.create(repo, recursive=TRUE)
  repo <- normalizePath(repo)
  .deployPackage(system.file("testData/helloWorld", package="sessionTools"), repo)
  
  ## convert repo path to a url
  if(.Platform$OS.type == "windows"){
    repo <- sprintf("file:%s",repo)
  }else{
    repo <- sprintf("file://%s", repo)
  }
  save(repo, file= file.path(tempdir(), "repo.rbin"))
  
  ## make sure that helloWorld is not already installed
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
  
  ## uninstall helloWorld if it's still attached/installed
  if('helloWorld' %in% installed.packages()[,1])
    remove.packages('helloWorld', lib=.libPaths())
  
  ## put back the libPaths
  load(file= file.path(tempdir(), "lib.rbin"))
  .libPaths(setdiff(.libPaths(), lib))
  
  ## clean up the local repo
  load(file= file.path(tempdir(), "repo.rbin"))
  unlink(repo, recursive = TRUE, force = TRUE)
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



