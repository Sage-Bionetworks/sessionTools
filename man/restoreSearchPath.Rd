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
Matthew D. Furia <matt.furia@sagebase.org>
}
\note{
This function is somewhat experimental and so it might not be possible to restore
all search path elements.
}

\seealso{
\code{\link{describeSession}}
}
\examples{
## The function is currently defined as
function (sessionInfo, envir = .GlobalEnv, clean = TRUE) 
{
    if (is.null(sessionInfo$search)) 
        invisible(NULL)
    indx <- grep("^package:", sessionInfo$search)
    lapply(indx, function(ii) {
        name <- sessionInfo$search[[ii]]
        if (name \%in\% search()) {
            if (ii == which(search() == name)) 
                return(NULL)
            detach(name, character.only = TRUE)
        }
        pkgName <- gsub("^package:", "", name)
        base::library(pkgName, pos = ii, character.only = TRUE)
    })
    indx <- grep("^[^package:]", sessionInfo$search)
    lapply(indx, function(ii) {
        name <- sessionInfo$search[[ii]]
        obj <- sessionInfo$searchpaths[[ii]]
        if (name \%in\% search()) {
            detach(name, character.only = TRUE)
        }
        attach(get(obj, envir = envir), pos = ii, name = name, 
            character.only = TRUE)
    })
    if (clean) {
        indx <- which(!(search \%in\% info$search))
        if (length(indx) > 0) {
            lapply(indx, function(ii) {
                name <- info$search[[ii]]
                detach(name, character.only = TRUE)
            })
        }
    }
    invisible(NULL)
  }
}
