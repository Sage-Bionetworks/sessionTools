\name{restorePackages}
\alias{restorePackages}
\title{
Restore Session Packages
}
\description{
Install packages that are missing from the local package library, but are described
in the sessionInfo object. Future releases of this package will potentially allow 
the caller to specify package version options such as "latest", "referenced" for each
package so that the each packge can be either upgraded to the latest version (if installed),
or moved to the version referenced in the sessionInfo object, or left unchanged.

Currently, this function will only install a package if it is not already installed, and will
always install the latest version available from the repository. If a package is already installed
the installed version will be left intact.

}
\usage{
restorePackages(sessionInfo, repos = getRepos(), warn = TRUE)
}
\arguments{
  \item{sessionInfo}{
A sessionInfo object
}
  \item{repos}{
The repositories to search for packages
}
  \item{warn}{
Boolean indicating whether a warning be displayed if not all packages can be installed.  
}
}
\value{
This method is executed for it's side-effects, which is to install packages to the default library.
}
\author{
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\examples{
\dontrun{
## get the session description
info <- sessionSummary()

## save to a binary
save(info, file="sessionInfo.rbin")

## restore
load(file = "sessionInfo.rbin")
restorePackages(info)

}
}
