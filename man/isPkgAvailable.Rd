\name{isPkgAvailable}
\alias{isPkgAvailable}
\title{
Check Availability of R Packages
}
\description{
Check the repositories for availability of packages and return a boolean
indicating whether the package is found.
}
\usage{
isPkgAvailable(pkg, repos = getOption("repos"), version)
}
\arguments{
\item{pkg}{
package names. Either a single string or an array of strings.
}
\item{repos}{
Repositories to search.
}
\item{version}{
The specific package version. Currently ignored.
}
}

\value{
Boolean indicating whether the package is available. One boolean for each package
name provided.
}
\author{
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\seealso{
\code{\link{restorePackages}}
}
\examples{
\dontrun{
ans <- isPkgAvailable(c("Biobase", "stats", "thisIsAFakePackage"))
}
}
