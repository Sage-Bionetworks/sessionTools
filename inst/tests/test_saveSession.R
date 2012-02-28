## Test saving sessions
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
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

