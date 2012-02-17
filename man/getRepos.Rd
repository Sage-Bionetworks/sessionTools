\name{getRepos}
\alias{getRepos}
\title{
	Get a List of Know Package Repositories
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
	Matthew D. Furia <matt.furia@sagebase.org>
}
\examples{

## The function is currently defined as
function () 
{
    repos <- tryCatch(BiocInstaller::biocinstallRepos(), error = function(e) {
        local({
            source("http://bioconductor.org/biocLite.R")
        })
        repos <- BiocInstaller::biocinstallRepos()
        remove.packages("BiocInstaller")
        repos
    })
    nms <- setdiff(names(getOption("repos")), names(repos))
    if (length(nms) > 0) 
        repos <- c(repos, getOption("repos")[nms])
    rVersion <- paste(R.Version()$major, as.integer(R.Version()$minor), 
        sep = ".")
    sageRepos <- paste("http://sage.fhcrc.org/CRAN/prod", rVersion, 
        sep = "/")
    repos <- c(repos, SageBio = sageRepos)
  }
}
