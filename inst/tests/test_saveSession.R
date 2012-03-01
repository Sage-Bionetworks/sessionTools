## filename: test_saveSession.R
## description: Test saving sessions.
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

