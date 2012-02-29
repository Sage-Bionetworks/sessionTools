\name{saveSession}
\alias{saveSession}
\title{
Save an R Session
}
\description{
This function saves all objects in stored in the global workspace, and also
saves the session info object that describes other information about the session.
It is a thin wrapper on the save method.
}
\usage{
saveSession(..., list = character(), file="session.RData", version = NULL, envir = .GlobalEnv)
}
\arguments{
\item{list}{
A character vector containing the names of objects to be
saved.
}
\item{\dots}{
the names of the objects to be saved (as symbols or character
strings).
}
\item{file}{
a (writable binary-mode) connection or the name of the file
where the data will be saved (when tilde expansion is done).
Must be a file name for version = 1.
}
\item{version}{
the workspace format version to use.  NULL specifies the
current default format.  The version used from R 0.99.0 to R
1.3.1 was version 1.  The default format as from R 1.4.0 is
version 2.
}
\item{envir}{
environment to search for objects to be saved.
}
}
\details{
This function is a thin wrapper on top of save.image(). The only difference being that
the sessionInfo object is first stored in the global environment as an object named
.sessionInfo.
}
\value{
This method is called for it's side-effects, which is a file storing the current session.
}
\author{
Matthew D. Furia \email{matt.furia@sagebase.org}

\url{https://github.com/MattNapsAlot}
}
\seealso{
\code{\link{restoreSession}},
\code{\link{sessionSummary}},
\code{\link{save}}
}
\examples{
\dontrun{
## save the session for later use
saveSession(file="sessionInfo.rbin")
}
}
