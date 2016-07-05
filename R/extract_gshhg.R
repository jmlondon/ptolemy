#' Extract Region from GSHHG
#' 
#' Functions to extract specified N. Pacific regions from the GSHHG dataset
#'
#' @param xlims a vector of x coordinate limits; 0-360 degrees
#' @param ylims a vector of y coordinate limits: 0-90 degrees
#' @param resolution either "f", "h", "i", or "c"
#' @param epsg character indicating the numeric epsg value (e.g. "3571")
#' @param fortify TRUE/FALSE whether to return a fortified data.frame for ggplot
#'
#' @return
#' @export
#'
#' @examples
extract_gshhg <- function(xlims,ylims,
                          resolution = "h", epsg,
                          fortify = TRUE) {
  dir_path <- system.file("extData", package = "nPacMaps")
  file_name <- paste0("gshhs_",resolution,".b")
  gshhg_path <- paste(dir_path, "gshhg-bin-2.3.5", file_name, sep = "/")
  
  this_extract <- maptools::Rgshhs(gshhg_path,xlim = xlims, ylim = ylims,
                         level = 1, checkPolygons = TRUE, shift = TRUE)
  this_extract <- sp::spTransform(this_extract$SP,CRS(paste0("+init=epsg:",epsg)))
  if (fortify) {
    this_extract <- ggplot2::fortify(this_extract)
  }
  return(this_extract)
}

#' @rdname extract_gshhg
bering <- function(...) {
  extract_gshhg(..., xlims = c(180 - 30,180 + 45),
                ylims = c(35,75), resolution = "h",
                epsg = "3571")
}

#' @rdname extract_gshhg
alaska <- function(...) {
  extract_gshhg(..., xlims = c(180 - 5,180 + 50),
                ylims = c(35,75), resolution = "h",
                epsg = "3338")
}

#' @rdname extract_gshhg
us_arctic <- function(...) {
  extract_gshhg(..., xlims = c(180 - 2,180 + 50),
                ylims = c(60,90), resolution = "h",
                epsg = "3572")
}

#' @rdname extract_gshhg
npac <- function(...) {
  extract_gshhg(..., xlims = c(180 - 50,180 + 70),
                ylims = c(20,67), resolution = "i",
                epsg = "3832")
}
