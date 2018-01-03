#' Download and Install GSHHG Binary Data
#'
#' @return NULL
#' @export
#'
install_gshhg <- function() {
  if (!dir.exists(system.file("extData", package = "nPacMaps"))) {
    dir.create(system.file("extData", package = "nPacMaps"))
  }
  data_path <- system.file("extData", package = "nPacMaps")
  
  if (!file.exists(paste(data_path, "gshhg-bin-2.3.6", sep = "/"))) {
    cont <- readline(
      prompt = "Download and install source gshhg data (Y,n)? "
      )
    if (cont == "Y") {
      tmp <- tempfile(fileext = ".zip")
      download.file(
        "https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/latest/gshhg-bin-2.3.6.zip",
                    tmp)
      unzip(tmp, 
            exdir = paste(data_path, 
                          "gshhg-bin-2.3.6", 
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
