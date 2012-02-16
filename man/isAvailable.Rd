\name{isAvailable}
\alias{isAvailable}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
	Check Availability of R Packages
}
\description{
	Check the repositories for availability of packages and return a boolean
	indicating whether the package is found.
}
\usage{
isAvailable(pkg, repos = getOption("repos"), version)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pkg}{
	package names. Either a single string or an array of strings.
}
  \item{repos}{
	Respoitories to search.
}
  \item{version}{
	The specific package version. Currently ignored.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
	Boolean indicating whether the package is available. One boolean for each package
	name provided.
}
\author{
	Matthew D. Furia <matt.furia@sagebase.org>
}
\seealso{
	\code{\link{restorePackages}}
}
\examples{
## The function is currently defined as
function (pkg, repos = getOption("repos"), version) 
{
    apkg <- data.frame(available.packages(contriburl = contrib.url(repos)), 
        stringsAsFactors = FALSE)
    pkg \%in\% apkg$Package
  }
}
