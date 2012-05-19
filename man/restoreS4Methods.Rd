\name{restoreS4Methods}
\alias{restoreS4Methods}
\title{
Restore Session Class Definitions
}
\description{
Restores the class definitions from an R binary file to the specified environment.
}
\usage{
restoreS4Methods(file = "session.RData", envir = .GlobalEnv, clean = TRUE, srcEnv)
}
\arguments{
\item{file}{
path to an R binary file
}
\item{envir}{
the environment into which the class definitions should be restored.
}
\item{clean}{
boolean indicating whether the environment should be purged of existing class definitions prior to restoring
}
\item{srcEnv}{
environment from which to restore generics. if this argument is provided the "file" arguments is ignored.
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
## make some methods
setGeneric("foo", def = function(bar) standardGeneric("foo"))
setMethod("foo", definition = function(bar) print(foo))

## save the session
sessionFile <- tempfile(fileext=".rbin")
saveSession(list = ls(), file = sessionFile)

## create an environment where they can be restored
env <- new.env()

## restore the generic
restoreS4Methods(file = sessionFile, envir = env)
getGenerics(env)
findMethods("foo", where=env)

}
