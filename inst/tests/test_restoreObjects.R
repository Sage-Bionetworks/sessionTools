## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: test_restoreObjects.R
## description: Test restoring objects.
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
  checkTrue(all(objects(env1, all.names=T) %in% objects(env2, all.names=T)))
  checkEquals(length(objects(env1, all.names=T)), length(objects(env2, all.names=T)))
  
  for(o in objects(env1, all.names=T)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}

unitTestRestoreObjectsOmitClasses <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setClass("foo", where = env1)
  rm(".packageName", envir=env1)
  
  assign(".foo", "bar", envir = env1)
  assign(".blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  removeClass("foo", where=env1)
  
  env2 <- new.env()
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1, all.names=T) %in% objects(env2, all.names=T)))
  checkEquals(length(objects(env1, all.names=T)), length(objects(env2, all.names=T)))
  
  for(o in objects(env1, all.names=T)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}

unitTestRestoreObjectsOmitGenerics <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setGeneric("foo", def = function(boo) standardGeneric("foo"), where = env1)
  rm(".packageName", envir=env1)
  
  assign(".foo", "bar", envir = env1)
  assign(".blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  removeGeneric("foo", where=env1)
  
  env2 <- new.env()
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1, all.names=T) %in% objects(env2, all.names=T)))
  checkEquals(length(objects(env1, all.names=T)), length(objects(env2, all.names=T)))
  checkEquals(length(getGenerics(env2)), 0L)
  
  for(o in objects(env1, all.names=T)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}


unitTestRestoreObjectsOmitS4Methods <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setGeneric("foobb", def = function(boo) standardGeneric("foo"), where = env1)
  setMethod("foobb", signature="character", definition = function(boo) print(boo), where = env1)
  
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  removeMethod("foobb", signature = "character", where=env1)
  removeGeneric("foobb", where = env1)
  rm(".packageName", envir=env1)
  
  env2 <- new.env()
  
  restoreObjects(file="session.RData", envir = env2)
  checkTrue(all(objects(env1, all.names=T) %in% objects(env2, all.names=T)))
  checkEquals(length(objects(env1, all.names=T)), length(objects(env2, all.names=T)))
  checkEquals(length(getGenerics(env2)), 0L)
  
  for(o in objects(env1, all.names=T)){
    checkEquals(get(o, envir = env1), get(o, envir = env2))
  }
}
