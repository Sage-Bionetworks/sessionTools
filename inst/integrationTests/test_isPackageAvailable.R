## unit tests for package availability function. Run agaings a remote CRAN mirror
## 
## Author: Matthew D. Furia <matt.furia@sagebase.org>
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
