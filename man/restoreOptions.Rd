\name{restoreOptions}
\alias{restoreOptions}
\title{
Restore R Options.
}
\description{
Restore R options from a sessionInfo object.
}
\usage{
restoreOptions(sessionInfo)
}
\arguments{
  \item{sessionInfo}{
A valid sessionInfo object.
}
}
\details{
This function only restores a subset of the options from a session. Currently
only "repos" is restored.
}
\value{
This method is called for it's side-effect of setting option values.
}
\author{
Matthew D. Furia <matt.furia@sagebase.org>
}

\seealso{
\code{\link{options}}
}
\examples{
function (sessionInfo) 
{
    kOptions <- "repos"
    options(sessionInfo$opts[kOptions])
  }
}
