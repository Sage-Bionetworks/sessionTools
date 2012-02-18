\name{packageInfo}
\alias{packageInfo}
\title{
Extract Package Info
}
\description{
Extracts package names and versions from the sessionInfo object.
}
\usage{
packageInfo(sessionInfo = sessionInfo())
}
\arguments{
  \item{sessionInfo}{
sessionInfo object from a call to \code{\link{sessionInfo}} or \code{\link{describeSession}}
}
}
\value{
A list containing the following elements:
\item{loadedOnly }{packages loaded via a namespace}
\item{otherPackages }{packages attached by a call to \code{library}}

Each element of the list contains a named list where the name is the package name and
the value is the package version.
}

\details{
This method is intended to be used to get a listing of optional packages that are loaded in
the current session. Packages listed in the "otherPackages" component are optional packages that
were attached to the search path using a call to library. Packges listed in the "loadedOnly" 
component were imported into the namespace of one of the "otherPackages", but are not attached
to the search path.
}

\author{
Matthew D. Furia <matt.furia@sagebase.org>
}
\seealso{
\code{\link{sessionInfo}},
\code{\link{describeSession}}
}
\examples{
## The function is currently defined as
function (sessionInfo = sessionInfo()) 
{
    pkgs <- list()
    pkgs$loadedOnly <- sapply(names(sessionInfo$loadedOnly), 
        function(pkg) {
            sessionInfo$loadedOnly[[pkg]]$Version
        })
    pkgs$otherPkgs <- sapply(names(sessionInfo$otherPkgs), function(pkg) {
        sessionInfo$otherPkgs[[pkg]]$Version
    })
    pkgs
  }
}
