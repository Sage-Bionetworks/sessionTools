\name{restoreSearchPath}
\alias{restoreSearchPath}
\title{
Restore a Search Path
}
\description{
Set the current session's search path to be equal to the search path
described in the sessionInfo object.
}
\usage{
restoreSearchPath(sessionInfo, envir = .GlobalEnv, clean = TRUE)
}
\arguments{
  \item{sessionInfo}{
A sessionInfo object containing search path info
}
  \item{envir}{
Environment to search for non-package objects that are referenced
in the sessionInfo object.
}
  \item{clean}{
Boolean indicating whether elements in current session's search path
that are not in the sessionInfo's search path should be removed.
}
}
\value{
This method is executed for it's side-effects, which is a modified search path.
}
\author{
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\note{
This function is somewhat experimental and so it might not be possible to restore
all search path elements.
}

\seealso{
\code{\link{sessionSummary}}
}
\examples{
\dontrun{
## get the session info
info <- sessionSummary()

## save to a file
save(info, file = "sessionInfo.rbin")

## load the session info
load("sessionInfo.rbin")

## restore the search path
restoreSearchPath(info)
}
}
