\name{hello}
\alias{hello}
\title{
  Hello World
}
\description{
  A classic hello world.
}
\usage{
hello(who = "world")
}
\arguments{
  \item{who}{
  Who to say hello to. Defaults to "World".
}
}
\details{
  Not much else to say.
}
\value{
  Prints out a greeting.
}
\author{
  Matt Furia
}

\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (who = "world") 
{
    cat(sprintf("Hello \%s!\n", who))
  }
}
