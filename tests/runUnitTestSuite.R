# This should be executed during R CMD check
# 
# Author: Matthew D. Furia <matt.furia@sagebase.org
###############################################################################
require(sessionTools) || stop("Could not load sessionTools package")
sessionTools:::.test()
