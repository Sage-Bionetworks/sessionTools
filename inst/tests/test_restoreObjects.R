## filename: test_restoreObjects.R
## description: Test restoring objects.
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
  env <- new.env()
  objects <- ls(.GlobalEnv, all.names = TRUE)
  lapply(objects, function(o){assign(o, get(o, envir = .GlobalEnv), envir=env)})
  save(env, file = file.path(tempdir(), "env.rbin"))
}

.tearDown <-
    function()
{
  load(file.path(tempdir(), "env.rbin"))
  objects <- ls(env, all.names = TRUE)
  lapply(objects, function(o){assign(o, get(o, envir = env), envir = .GlobalEnv)})
}

unitTestRestoreBasic <-
    function()
{
  env1 <- new.env()
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkEquals(length(objects(env1)), length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
  
}

unitTestRestoreClean <-
    function()
{
  
  env1 <- new.env()
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  assign("blah", "boo", envir = env2)
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkEquals(length(objects(env1)), length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
  
}

unitTestRestoreCleanOverwrite <-
  function()
{
  env1 <- new.env()
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  assign("blah", "boo", envir = env2)
  assign("foo", "gah", envir = env2)
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkEquals(length(objects(env1)), length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}

unitTestRestoreNoCleanOverwrite <-
  function()
{
  
  env1 <- new.env()
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  assign("blah", "boo", envir = env2)
  assign("foo", "gah", envir = env2)
  
  restoreObjects(file="session.RData", envir = env2, clean = FALSE)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkTrue("blah" %in% objects(env2))
  checkEquals(length(objects(env1)) + 1, length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
  
  checkEquals(get("blah", envir = env2), "boo")
}

unitTestRestoreNoClean <-
  function()
{
  env1 <- new.env()
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  assign("blah", "boo", envir = env2)
  
  restoreObjects(file="session.RData", envir = env2, clean = FALSE)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkEquals(length(objects(env1)) + 1, length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  } 
}

unitTestRestoreObjectsStartingWithDot <-
  function()
{
  env1 <- new.env()
  assign(".foo", "bar", envir = env1)
  assign(".blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  env2 <- new.env()
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1) %in% objects(env2)))
  checkEquals(length(objects(env1)), length(objects(env2)))
  
  for(o in objects(env1)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}


