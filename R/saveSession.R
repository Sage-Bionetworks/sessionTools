saveSession <- 
		function(file="session.RData", ...)
{
        .sessionInfo <<- describeSession()
        save(list = ls(envir = .GlobalEnv, all.names = TRUE), file = file, ...)
}


