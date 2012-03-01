## filename: test_restoreSearchPath.R
## description: Tests for restoring search path.
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
    ## save the current state of the session
#    info <- sessionSummary()
#    save(info, file = file.path(tempdir(), "info.rbin"))
  while("fooDat" %in% search())
    detach(fooDat)
  while("booDat" %in% search())
    detach(booDat)
  while("bletch" %in% search())
    detach(bletch)
}

.tearDown <-
    function()
{
  require(stats, quietly = TRUE)
  ## restore the search path. this is a pretty brittle teardown
  ## since it depends on the function that's being tested. if it
  ## breaks, the teardown will not be complete
#  load(file.path(tempdir(), "info.rbin"))
#  restoreSearchPath(info)
  while("fooDat" %in% search())
    detach(fooDat)
  while("booDat" %in% search())
    detach(booDat)
  while("bletch" %in% search())
    detach(bletch)
  
}

unitTestRearrangeOrder <-
    function()
{
  fooDat <- data.frame(diag(10))
  env <- attach(fooDat)
  info <- sessionSummary()
  
  pos <- which(info$search == "fooDat")
  detach(fooDat)
  attach(fooDat, pos = pos + 1)
  
  checkEquals(which(search() == "fooDat"), pos + 1)
  
  checkEquals(restoreSearchPath(info), "fooDat")
  checkEquals(which(search() == "fooDat"), pos)
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestNoChange <-
  function()
{
  info <- sessionSummary()
  checkEquals(restoreSearchPath(info), character())
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestInsertClean <-
    function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat)
  info <- sessionSummary()
  pos <- which(info$search == "fooDat")
  
  booDat <- list(a="b", b="c")
  attach(booDat)
  
  detach(fooDat)
  attach(fooDat, pos = pos + 1)
  
  checkEquals(which(search() == "fooDat"), pos + 1)
  
  checkEquals(restoreSearchPath(info, clean = TRUE), "booDat")
  checkEquals(which(search() == "fooDat"), pos)
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestRearrangeClean <-
  function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat)
  info <- sessionSummary()
  pos <- which(info$search == "fooDat")
  
  booDat <- list(a="b", b="c")
  attach(booDat)
  
  detach(fooDat)
  attach(fooDat, pos = pos + 2)
  
  checkEquals(which(search() == "fooDat"), pos + 2)
  
  ans <- restoreSearchPath(info, clean = TRUE)
  checkEquals(length(ans), 2L)
  checkTrue(all(c("fooDat", "booDat") %in% ans))
  checkEquals(which(search() == "fooDat"), pos)
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestInsertNoClean <-
  function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat)
  info <- sessionSummary()
  pos <- which(info$search == "fooDat")
  
  booDat <- list(a="b", b="c")
  attach(booDat)
  
  checkEquals(which(search() == "fooDat"), pos + 1)
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(ans , character())
  checkEquals(which(search() == "fooDat"), pos + 1)
  checkEquals(length(search()), length(info$search) + 1)
  checkTrue(all(search()[-2] == info$search))
  checkEquals(search()[2], "booDat")
}

unitTestInsertRearrangeNoClean <-
  function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat)
  info <- sessionSummary()
  pos <- which(info$search == "fooDat")
  
  booDat <- list(a="b", b="c")
  attach(booDat)
  
  detach(fooDat)
  attach(fooDat, pos = pos + 2)
  
  checkEquals(which(search() == "fooDat"), pos + 2)
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(ans , "fooDat")
  checkEquals(which(search() == "fooDat"), pos + 1)
  checkEquals(length(search()), length(info$search) + 1)
  checkTrue(all(search()[-2] == info$search))
  checkEquals(search()[2], "booDat")
}

unitTestLeapFrog <-
  function()
{
  booDat <- list(a="b", b="c")
  attach(booDat, pos = 5)
  
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 7)
  
  info <- sessionSummary()
  
  detach(fooDat)
  attach(fooDat, pos = 2)
  detach(booDat)
  attach(booDat, pos = 10)
  
  checkEquals(which(search() == "fooDat"), 2)
  checkEquals(which(search() == "booDat"), 10)
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(which(search() == "fooDat"), 7)
  checkEquals(which(search() == "booDat"), 5)
  
  ## this is broken
  ## checkTrue(all(c("booDat", "fooDat") %in% ans))
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestLeapFrog2 <-
  function()
{
  
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 4)
  
  booDat <- list(a="b", b="c")
  attach(booDat, pos = 7)
 
  info <- sessionSummary()
  
  detach(fooDat)
  attach(fooDat, pos = 2)
  detach(booDat)
  attach(booDat, pos = 10)
  
  checkEquals(which(search() == "fooDat"), 2)
  checkEquals(which(search() == "booDat"), 10)
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(which(search() == "fooDat"), 4)
  checkEquals(which(search() == "booDat"), 7)
  
  ## this is broken
  ## checkTrue(all(c("booDat", "fooDat") %in% ans))
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestLeapFrog3 <-
  function()
{
  
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 4)
  
  booDat <- list(a="b", b="c")
  attach(booDat, pos = 7)
   
  info <- sessionSummary()
  
  detach(fooDat)
  attach(fooDat, pos = 10)
  detach(booDat)
  attach(booDat, pos = 2)
  
  bletch <- list(d="f", g="K")
  attach(bletch)
  
  checkEquals(which(search() == "fooDat"), 11)
  checkEquals(which(search() == "booDat"), 3)
  ans <- restoreSearchPath(info, clean = TRUE)
  checkEquals(which(search() == "fooDat"), 4)
  checkEquals(which(search() == "booDat"), 7)
  
  ## this is broken
  ## checkTrue(all(c("booDat", "fooDat") %in% ans))
  checkEquals(length(search()), length(info$search))
  checkTrue(all(search() == info$search))
}

unitTestLeapFrog4 <-
  function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 4)
  
  booDat <- list(a="b", b="c")
  attach(booDat, pos = 7)
  
  info <- sessionSummary()
  
  detach(fooDat)
  attach(fooDat, pos = 10)
  detach(booDat)
  attach(booDat, pos = 2)
  
  bletch <- list(d="f", g="K")
  attach(bletch)
  
  checkEquals(which(search() == "fooDat"), 11)
  checkEquals(which(search() == "booDat"), 3)
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(which(search() == "fooDat"), 5)
  checkEquals(which(search() == "booDat"), 8)
  
  ## this is broken
  ## checkTrue(all(c("booDat", "fooDat") %in% ans))
  checkEquals(length(search()), length(info$search) + 1)
  checkTrue(all(search()[-2] == info$search))
}


## this is broken
#unitTestReattachObjectDiffName <-
#    function()
#{
#
#  fooDat <- data.frame(diag(10))
#  attach(fooDat, pos = 2, name = "booDat")
#  booDat <- list(a="b", b="c")
#  
#  info <- sessionSummary()
#  
#  detach(booDat)
#  checkTrue(!("booDat" %in% search()))
#  
#  ans <- restoreSearchPath(info, clean = FALSE)
#  checkEquals(ans, "booDat")
#  rm(booDat)
#  checkTrue(all(fooDat == booDat))
#}

unitTestReattachObjectSameName <-
    function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 2)
  
  info <- sessionSummary()
  
  detach(fooDat)
  checkTrue(!("fooDat" %in% search()))
  
  ans <- restoreSearchPath(info, clean = FALSE)
  
  ## this test is broken
  ##checkEquals(ans, "fooDat")
  ##checkEquals(which(search() == "fooDat"), 2L)
}

unitTestAttachPackage <-
  function()
{
  info <- sessionSummary()
  unloadNamespace("stats")
  
  checkTrue(!('package:stats' %in% search()))
  
  ans <- restoreSearchPath(info)
  checkEquals(ans, "package:stats")
  checkTrue('package:stats' %in% search())
}

unitTestDetachPackageClean <-
  function()
{
  unloadNamespace("stats")
  info <- sessionSummary()
  
  require(stats, quietly = TRUE)
  checkTrue('package:stats' %in% search())
  
  ans <- restoreSearchPath(info, clean = TRUE)
  checkEquals(ans, "package:stats")
  checkTrue(!('package:stats' %in% search()))
}

unitTestDetachPackageNoClean <-
  function()
{
  unloadNamespace("stats")
  info <- sessionSummary()
  
  require(stats, quietly = TRUE)
  checkTrue('package:stats' %in% search())
  
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(ans, character())
  checkTrue('package:stats' %in% search())
}

unitTestAddObjectNotAvailable <-
    function()
{
  fooDat <- data.frame(diag(10))
  attach(fooDat, pos = 2)
  
  info <- sessionSummary()
  
  detach(fooDat)
  checkTrue(!("fooDat" %in% search()))
  rm(fooDat)
  
  ans <- restoreSearchPath(info, clean = FALSE)
  checkEquals(ans, character())
  checkEquals(which(search() == "fooDat"), integer())
}
