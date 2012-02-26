## Test restoring objects
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
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


