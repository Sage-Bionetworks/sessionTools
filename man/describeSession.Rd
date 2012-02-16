\name{describeSession}
\alias{describeSession}
\title{
	Return a sessionInfo object
}
\description{
	 Create a sessionInfo object that can be used to describe the current session.
}
\usage{
	describeSession()
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%% 
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\author{
	Matthew D. Furia <matt.furia@saegebase.org>
}

\seealso{
	\code{\link{restoreSession}}
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
