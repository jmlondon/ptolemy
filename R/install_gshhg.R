#' Download and Install GSHHG Binary Data
#' 
#' This is a function for downloading and installing the latest version of the
#' GSHHG binary dataset. Current version supported is 2.3.7. This only needs
#' to be run once after the package is installed. 
#'
#' @return NULL
#' @export
#'
install_gshhg <- function() {
  if (!dir.exists(system.file("extData", package = "ptolemy"))) {
    dir.create(system.file("extData", package = "ptolemy"))
  }
  data_path <- system.file("extData", package = "ptolemy")
  
  if (!file.exists(paste(data_path, "gshhg-bin-2.3.7", sep = "/"))) {
    cont <- readline(
      prompt = "Download and install source gshhg data (Y,n)? "
      )
    if (cont == "Y") {
      tmp <- tempfile(fileext = ".zip")
      download.file(
        "https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/latest/gshhg-bin-2.3.7.zip",
                    tmp)
      unzip(tmp, 
            exdir = paste(data_path, 
                          "gshhg-bin-2.3.7", 
                          sep = "/"))
      unlink(tmp)
    } else if (cont == "n") {
      message("Source data will not be downloaded")
    } else {
      message("You must respond with Y or n")
    }
  } else {
    message("Source data already installed")
  }
}
