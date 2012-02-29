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
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}

\examples{
## make some objects
aMatrix <- diag(10)
letters <- c("a", "b", "c")

## save the session
sessionFile <- tempfile(fileext=".rbin")
saveSession(list = ls(), file = sessionFile)

## create an environment where they can be restored
env <- new.env()

## assign an object
assign("goo", 1:10, envir = env)

## restore the objects leaving "goo"
restoreObjects(file = sessionFile, envir = env, clean = FALSE)
ls(env)

## restore the objects again, this time delete all objects from env first
restoreObjects(file = sessionFile, envir = env, clean = TRUE)
ls(env)
}
