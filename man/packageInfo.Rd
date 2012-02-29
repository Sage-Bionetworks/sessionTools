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
sessionInfo object from a call to \code{\link{sessionInfo}} or \code{\link{sessionSummary}}
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
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\seealso{
\code{\link{sessionInfo}},
\code{\link{sessionSummary}}
}
\examples{
info <- sessionInfo()
pkg.info <- packageInfo(info)

info <- sessionSummary()
pkg.info <- packageInfo(info)
}
