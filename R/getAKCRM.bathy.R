#' getAKCRM.bathy
#'
#' a modification of the getNOAA.bathy() function in the marmap package
#'
#' this allows one to pull bathymetry data from the South Alaska CRM
#' 24-arc second resolution dataset for Alaska. Unlike getNOAA.bathy(),
#' the bounding box coordinates should be from 0-360
#'
#' @param lon1 
#' @param lon2
#' @param lat1
#' @param lat2
#' @param resolution
#' @param keep 
#' @return bathy class object
#' @author Josh M London
#' @export
getAKCRM.bathy <- function (lon1, lon2, lat1, lat2, resolution = 0.4, keep = FALSE) {
  x1 = x2 = y1 = y2 = NULL
  if (lon1 < lon2) {
    x1 <- lon1
    x2 <- lon2
  }
  else {
    x2 <- lon1
    x1 <- lon2
  }
  if (lat1 < lat2) {
    y1 <- lat1
    y2 <- lat2
  }
  else {
    y2 <- lat1
    y1 <- lat2
  }
  res = resolution * 0.0166666666666667
  fetch <- function(x1, y1, x2, y2, res) {
    WEB.REQUEST <- paste("http://maps.ngdc.noaa.gov/mapviewer-support/wcs-proxy/wcs.groovy?filename=alaska_crm.xyz&request=getcoverage&version=1.0.0&service=wcs&coverage=alaska_crm&CRS=EPSG:4326&format=xyz&resx=", 
                         res, "&resy=", res, "&bbox=", x1, ",", y1, ",", x2, 
                         ",", y2, sep = "")
    dat <- suppressWarnings(try(read.table(WEB.REQUEST), 
                                silent = TRUE))
    return(dat)
  }
  FILE <- paste("marmap_coord_", x1, ";", y1, ";", x2, 
                  ";", y2, "_res_", resolution, ".csv", sep = "")

  if (FILE %in% list.files()) {
    cat("File already exists ; loading '", FILE, "'", sep = "")
    exisiting.bathy <- marmap::read.bathy(FILE, header = T)
    return(exisiting.bathy)
  }
  else {
      cat("Querying NOAA Alaska CRM database ...\n")
      cat("This may take seconds to minutes, depending on grid size\n")
      bath <- fetch(x1, y1, x2, y2, res)
      if (is(bath, "try-error")) {
        stop("The NOAA server cannot be reached\n")
      }
      else {
        cat("Building bathy matrix ...\n")
        bath2 <- marmap::as.bathy(bath)
      }
    if (keep) {
      write.table(bath, file = FILE, sep = ",", quote = FALSE, 
                  row.names = FALSE)
    }
    return(bath2)
  }
}
