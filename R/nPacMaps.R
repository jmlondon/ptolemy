#' North Pacific Maps
#'
#' @docType package
#' @name nPacMaps
NULL

.onAttach <- function(library, pkgname)
{
  info <- utils::packageDescription(pkgname)
  package <- info$Package
  version <- info$Version
  date <- info$Date
  packageStartupMessage(
    paste(paste(package, version, paste0("(",date, ")"), "\n"), 
          "The nPacMaps package requires an additional installation step.\n",
          "Please type 'install_gshhg()' to complete this install.\n"
          )
  )
  
}