\name{getRepos}
\alias{getRepos}
\title{
Get a List of Known Package Repositories
}
\description{
This package returns the urls to the currently know repositories. This includes
repositories listed in the user's "repos" option, bioconductor repos returned
by a call to biocinstallRepos() and also the Sage Bionetworks pulic respoitory.
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
