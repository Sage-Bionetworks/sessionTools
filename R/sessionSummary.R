# Return session description
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org>
###############################################################################

sessionSummary <-
    function()
{
  info <- sessionInfo()
  info$search <- search()
  info$searchpaths <- searchpaths()
  info$opts <- options()
  info
}





