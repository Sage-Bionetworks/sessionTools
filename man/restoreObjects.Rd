\name{restoreObjects}
\alias{restoreObjects}
\title{
	Restore Session Objects
}
\description{
	Restores the objects from an R binary file to the specified environment.
}
\usage{
	restoreObjects(file = "session.RData", envir = .GlobalEnv, clean = TRUE)
}
\arguments{
  \item{file}{
	path to an R binary file
}
  \item{envir}{
	the environment into which the objects should be restored.
}
  \item{clean}{
	boolean indicating whether the environment should be purged prior to restoring objects
}

}

\value{
	This method is executed for it's side-effects.
}
\author{
	Matthew D. Furia <matt.furia@sagebase.org>
}

\examples{

## The function is currently defined as
function (file = "session.RData", envir = .GlobalEnv, clean = TRUE) 
{
    if (clean) {
        names <- ls(all.names = TRUE, envir = envir)
        if (length(names) > 0) 
            rm(list = names, envir = envir)
    }
    load(file, envir = envir)
  }
}
