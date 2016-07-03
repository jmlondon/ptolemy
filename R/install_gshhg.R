install_gshhg <- function() {
  if (!dir.exists(system.file("extData", package = "nPacMaps"))) {
    dir.create(system.file("extData", package = "nPacMaps"))
  }
  data_path <- system.file("extData", package = "nPacMaps")
  
  if (!file.exists(paste(data_path, "gshhg-bin-2.3.5", sep = "/"))) {
    cont <- readline(
      prompt = "Download and install source gshhg data (Y,n)? "
      )
    if (cont == "Y") {
      tmp <- tempfile(fileext = ".zip")
      download.file(
        "ftp://ftp.soest.hawaii.edu/gshhg/gshhg-bin-2.3.5.zip",
                    tmp)
      unzip(tmp, 
            exdir = paste(data_path, 
                          "gshhg-bin-2.3.5", 
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
