## Copyright (C) 2012  Sage Bionetworks <www.sagebase.org>
##
## filename: test_isPackageAvailable.R
## description: unit tests for package availability function. Run against a 
## remote CRAN mirror.
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

integrationTestSinglePackageAvail <-
    function()
{
  checkTrue(isPkgAvailable('lattice',repos="http://cran.fhcrc.org"))
}

unitTestMultPackageAvail <-
    function()
{
  checkTrue(all(isPkgAvailable(c('lattice', 'RODBC'),repos="http://cran.fhcrc.org")))
}

unitTestOneAvailOneNot <-
    function()
{
  checkTrue(all(isPkgAvailable(c('lattice', 'fakePackge'),repos="http://cran.fhcrc.org") == c(TRUE,FALSE)))
}
