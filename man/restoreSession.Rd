\name{restoreSession}
\alias{restoreSession}
\title{
	Restore an R Session
}
\description{
	A wrapper function for storing a session.
}
\usage{
restoreSession(file = "session.RData", envir = .GlobalEnv, clean = TRUE, ...)
}
\arguments{
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{envir}{
%%     ~~Describe \code{envir} here~~
}
  \item{clean}{
%%     ~~Describe \code{clean} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}


\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (file = "session.RData", envir = .GlobalEnv, clean = TRUE, 
    ...) 
{
    if (clean) {
        names <- ls(all.names = TRUE, envir = envir)
        if (length(names) > 0) 
            rm(list = names, envir = envir)
    }
    load(file, envir = envir)
    if (!exists(".sessionInfo", envir = envir)) 
        invisible(NULL)
    restoreOptions(.sessionInfo)
    restorePackages(.sessionInfo)
    restoreSearchPath(.sessionInfo, envir = envir, clean = clean)
  }
}
