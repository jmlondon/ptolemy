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
  if (dir.exists(system.file("extData", package = "nPacMaps"))) {
    data_path <- system.file("extData", package = "nPacMaps")
  }
  if (!file.exists(paste(data_path, "gshhg-bin-2.3.7", sep = "/"))) {
  packageStartupMessage(
    paste(paste(package, version, paste0("(",date, ")"), "\n"), 
          "The nPacMaps package requires an additional installation step.\n",
          "Please type 'install_gshhg()' to install GSHHG v 2.3.7.\n"
          )
  )
  }
  
}
