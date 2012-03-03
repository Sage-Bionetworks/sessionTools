## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: test_sessionTools_package.R
## description: Function for running unit tests
## author: Matthew D. Furia <matt.furia@sagebase.org>
##
## This file is part of the sessionTools R package.
##
## sessionTools is free software: provided the Funding Acknolegement
## is maintained, you can redistribute it and/or modify it under the terms of 
## the GNU LGPL-3, either version 3 of the License, or (at your option) any 
## later version. For details visit <http://www.gnu.org/licenses/>.
##
## Funding Acknowledgement: 
## The development of this software was supported by NCI Integrative Cancer 
## Biology Program grant CA149237 and Washington State Life Science Discovery 
## Fund Program Grant 3104672 to Sage Bionetworks.
###############################################################################

.test <- function(dir=system.file("tests", package="sessionTools"), testFileRegexp = "^test_.*\\.R$") {
  .runTestSuite(dir=dir, testFileRegexp=testFileRegexp, testFuncRegexp="^unitTest.+", suiteName="unit tests") 
}

.integrationTest <- function(dir=system.file("integrationTests", package="sessionTools"), testFileRegexp = "^test_.*\\.R$") {
  .runTestSuite(dir=dir, testFileRegexp=testFileRegexp, testFuncRegexp="^integrationTest.+", suiteName="unit tests") 
}

.runTestSuite <- function(dir, testFileRegexp, testFuncRegexp, suiteName) {
  .failure_details <- function(result) {
    res <- result[[1L]]
    if (res$nFail > 0 || res$nErr > 0) {
      Filter(function(x) length(x) > 0,
          lapply(res$sourceFileResults,
              function(fileRes) {
                names(Filter(function(x) x$kind != "success",
                        fileRes))
              }))
    } else list()
  }
  
  require("RUnit", quietly=TRUE) || stop("RUnit package not found")
  RUnit_opts <- getOption("RUnit", list())
  RUnit_opts$verbose <- 0L
  RUnit_opts$silent <- TRUE
  
  RUnit_opts$verbose_fail_msg <- TRUE
  options(RUnit = RUnit_opts)
  suite <- defineTestSuite(name=paste("sessionTools RUnit Test Suite", suiteName), 
      dirs=dir,
      testFileRegexp=testFileRegexp,
      testFuncRegexp=testFuncRegexp,
      rngKind="default",
      rngNormalKind="default")
  result <- runTestSuite(suite)
  cat("\n\n")
  printTextProtocol(result, showDetails=FALSE)
  if (length(details <- .failure_details(result)) >0) {
    cat("\nTest files with failing tests\n")
    for (i in seq_along(details)) {
      cat("\n  ", basename(names(details)[[i]]), "\n")
      for (j in seq_along(details[[i]])) {
        cat("    ", details[[i]][[j]], "\n")
      }
    }
    cat("\n\n")
    stop(paste(suiteName, " tests failed for package sessionTools"))
  }
  result
}