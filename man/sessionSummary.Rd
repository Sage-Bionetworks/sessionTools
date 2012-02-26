\name{sessionSummary}
\alias{sessionSummary}
\title{
Return a sessionInfo object
}
\description{
 Create a sessionInfo object that can be used to describe the current session.
}
\usage{
sessionSummary()
}

\value{
A list containing the session information returned by sessionInfo() plus
the additional components listed below:
\item{search }{array of attached objects returned by a call to search()}
\item{searchpaths }{array of searchpaths returned by a call to searchpaths()}
\item{opts }{list containing the options returned by a call to options()}
}
\author{
Matthew D. Furia <matt.furia@saegebase.org>
}

\seealso{
\code{\link{restoreSession}},
\code{\link{sessionInfo}},
\code{\link{search}},
\code{\link{searchpaths}},
\code{\link{options}}
}
\examples{
function () 
{
    info <- sessionInfo()
    info$search <- search()
    info$searchpaths <- searchpaths()
    info$opts <- options()
    info
}
}
