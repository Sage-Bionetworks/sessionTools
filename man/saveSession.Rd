\name{saveSession}
\alias{saveSession}
\title{
Save an R Session
}
\description{
This function saves all objects in stored in the global workspace, and also
saves the session info object that describes other information about the session.
}
\usage{
saveSession(file = "session.RData", ...)
}
\arguments{
  \item{file}{
File where the session should be stored
}
  \item{\dots}{
Other arguments passed to save.
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
Matthew D. Furia <matt.furia@sagebase.org>
}

\seealso{
\code{\link{restoreSession}},
\code{\link{sessionSummary}}
}
\examples{

## The function is currently defined as
function (file = "session.RData", ...) 
{
    .sessionInfo <<- sessionSummary()
    save(list = ls(envir = .GlobalEnv, all.names = TRUE), file = file, 
        ...)
  }
}
