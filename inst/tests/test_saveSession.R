## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: test_saveSession.R
## description: Test saving sessions.
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

unitTestSaveSessionOne <-
  function()
{
  file <- tempfile(fileext=".rbin")
  env <- new.env()
  assign("foo", "bar", envir = env)
  assign("boo", "blah", envir = env)
  saveSession("foo", file=file, envir = env)
  checkTrue(file.exists(file))
  
  env2 <- new.env()
  load(file, envir = env2)
  checkEquals(length(ls(envir = env2, all.names = TRUE)), 2L)
  checkTrue(all(c("foo", ".sessionInfo") %in% ls(envir = env2, all.names = TRUE)))
  for(n in ls(envir=env2)){
    checkEquals(get(n, env2), get(n, env))
  }
}

unitTestSaveSessionStartsWithDot <-
  function()
{
  file <- tempfile(fileext=".rbin")
  env <- new.env()
  assign("foo", "bar", envir = env)
  assign("boo", "blah", envir = env)
  assign(".goo", "glitch", envir = env)
  saveSession(.goo, file=file, envir = env)
  checkTrue(file.exists(file))
  
  env2 <- new.env()
  load(file, envir = env2)
  checkEquals(length(ls(envir = env2, all.names = TRUE)), 2L)
  checkTrue(all(c(".goo", ".sessionInfo") %in% ls(envir = env2, all.names = TRUE)))
  n <- ".goo"
  checkEquals(get(n, env2), get(n, env))
}

unitTestSaveSessionAll <-
  function()
{
  file <- tempfile(fileext=".rbin")
  env <- new.env()
  assign("foo", "bar", envir = env)
  assign("boo", "blah", envir = env)
  saveSession(foo, boo, file=file, envir = env)
  checkTrue(file.exists(file))
  
  env2 <- new.env()
  load(file, envir = env2)
  checkEquals(length(ls(envir = env2, all.names = TRUE)), 3L)
  checkTrue(all(c("foo", "boo", ".sessionInfo") %in% ls(envir = env2, all.names = TRUE)))
  for(n in ls(envir=env2)){
    checkEquals(get(n, env2), get(n, env))
  }
}

unitTestSaveSessionAllByCharacterName <-
  function()
{
  file <- tempfile(fileext=".rbin")
  env <- new.env()
  assign("foo", "bar", envir = env)
  assign("boo", "blah", envir = env)
  saveSession("foo", "boo", file=file, envir = env)
  checkTrue(file.exists(file))
  
  env2 <- new.env()
  load(file, envir = env2)
  checkEquals(length(ls(envir = env2, all.names = TRUE)), 3L)
  checkTrue(all(c("foo", "boo", ".sessionInfo") %in% ls(envir = env2, all.names = TRUE)))
  for(n in ls(envir=env2)){
    checkEquals(get(n, env2), get(n, env))
  }
}

unitTestSaveSessionAllByList <-
  function()
{
  file <- tempfile(fileext=".rbin")
  env <- new.env()
  assign("foo", "bar", envir = env)
  assign("boo", "blah", envir = env)
  saveSession(list=ls(envir=env), file=file, envir = env)
  checkTrue(file.exists(file))
  
  env2 <- new.env()
  load(file, envir = env2)
  checkEquals(length(ls(envir = env2, all.names = TRUE)), 3L)
  checkTrue(all(c("foo", "boo", ".sessionInfo") %in% ls(envir = env2, all.names = TRUE)))
  for(n in ls(envir=env2)){
    checkEquals(get(n, env2), get(n, env))
  }
}

