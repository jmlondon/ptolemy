#' ptolemy: an R package for accessing global high-resolution geography
#'
#' @docType package
#' @name ptolemy
NULL

.onAttach <- function(library, pkgname)
{
  info <- utils::packageDescription(pkgname)
  package <- info$Package
  version <- info$Version
  date <- info$Date
  if (dir.exists(system.file("extData", package = "ptolemy"))) {
    data_path <- system.file("extData", package = "ptolemy")
  }
  if (!file.exists(paste(data_path, "gshhg-bin-2.3.7", sep = "/"))) {
  packageStartupMessage(
    paste(paste(package, version, paste0("(",date, ")"), "\n"), 
          "The ptolemy package requires an additional installation step.\n",
          "Please type 'install_gshhg()' to install GSHHG v 2.3.7.\n"
          )
  )
  }
  
}
