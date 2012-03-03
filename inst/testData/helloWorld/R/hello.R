## Say Hello
##
## Author: Matthew D. Furia <matt.furia@sagebase.org
########################################################

hello <-
  function(who = "world")
{
  cat(sprintf("Hello %s!\n", who))
}
