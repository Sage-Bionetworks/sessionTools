\name{packageInfo}
\alias{packageInfo}
\title{
	Some info
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
packageInfo(sessionInfo = sessionInfo())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sessionInfo}{
%%     ~~Describe \code{sessionInfo} here~~
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

## The function is currently defined as
function (sessionInfo = sessionInfo()) 
{
    pkgs <- list()
    pkgs$loadedOnly <- sapply(names(sessionInfo$loadedOnly), 
        function(pkg) {
            sessionInfo$loadedOnly[[pkg]]$Version
        })
    pkgs$otherPkgs <- sapply(names(sessionInfo$otherPkgs), function(pkg) {
        sessionInfo$otherPkgs[[pkg]]$Version
    })
    pkgs
  }
}
