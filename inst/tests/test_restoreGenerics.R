## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: test_restoreGenerics.R
## description: Test restoring S4 generics.
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


unitTestRestoreClassDefinitionsOmitObjects <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setGeneric("boo", def = function(bar){standardGeneric("boo")}, where = env1) 
  
  assign("foo", "bar", envir = env1)
  assign("blargh", "goo", envir = env1)
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  
  rm("foo", envir = env1)
  rm("blargh", envir = env1)
  rm(".packageName", envir=env1)
  
  env2 <- new.env()
  
  restoreGenerics(file="session.RData", envir = env2)
  checkTrue(all(objects(env1, all.names=T) %in% objects(env2, all.names=T)))
  checkEquals(length(objects(env1, all.names=T)), length(objects(env2, all.names=T)))
  
  checkEquals("boo", getGenerics(env2)@.Data)
}

unitTestRestoreGenericsClean <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setGeneric("foo", where = env1, def = function(who) standardGeneric("foo")) 
  
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  rm(".packageName", envir=env1)
  
  env2 <- new.env()
  setPackageName("foo2", env2)
  setGeneric("boo", where = env2, def = function(var1) standardGeneric("boo"))
  
  restoreGenerics(file = "session.RData", envir = env2)
  checkEquals(length(getGenerics(env2)), 1L)
  
  checkEquals(getGenerics(env2)@.Data, "foo")
}


unitTestRestoreGenericsNoClean <-
  function()
{
  env1 <- new.env()
  
  ## define a package
  setPackageName("pkgName", env1)
  setGeneric("foo", where = env1, def = function(who) standardGeneric("foo")) 
  
  save(list=ls(env1, all.names = TRUE), envir = env1, file = "session.RData")
  rm(".packageName", envir=env1)
  
  env2 <- new.env()
  setPackageName("foo2", env2)
  setGeneric("boo", where = env2, def = function(var1) standardGeneric("boo"))
  
  restoreGenerics(file = "session.RData", envir = env2, clean = FALSE)
  checkEquals(length(getGenerics(env2)), 2L)
  
  checkTrue(all(getGenerics(env2)@.Data %in% c("boo", "foo")))
}

