\name{getRepos}
\alias{getRepos}
\title{
Get a List of Known Package Repositories
}
\description{
This package returns the urls to the currently know repositories. This includes
repositories listed in the user's "repos" option and bioconductor repos returned
by a call to biocinstallRepos(). Future versions of this function may include
other dependable, publicly available R package repositories
}
\usage{
getRepos()
}
\value{
A named list of repository URLs.
}
\author{
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\examples{
## get the known repositories
\dontrun{
repos <- getRepos()
}
}
