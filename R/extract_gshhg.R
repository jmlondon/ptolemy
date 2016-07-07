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
#' @return NULL
#' @export
#'
extract_gshhg <- function(xlims,ylims,
                          resolution = "i", epsg,
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

#' Bering Sea Map Region
#' 
#' This map region is centered on the Bering Sea. Coordinates are returned in 
#' the Lambert-Azimuthal Equal Area Bering Sea Projection (epsg:3571)

#' @rdname extract_gshhg
#' @export
bering <- function(xlims = c(180 - 30,180 + 45),
                   ylims = c(35,75), resolution = "i",
                   epsg = "3571", fortify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                fortify = fortify)
}

#' Alaska Map Region
#' 
#' This map region covers the extent of Alaska. Coordinates are returned in the
#' Alaska Albers Projection (epsg:3338)
#' 
#' @rdname extract_gshhg
#' @export
alaska <- function(xlims = c(180 - 5,180 + 50),
                   ylims = c(35,75), resolution = "i",
                   epsg = "3338", fortify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                fortify = fortify)
}

#' US Arctic Map Region
#' 
#' This map region covers the US Arctic region centered on northern Alaska. The
#' region extends into the Russian East Siberian Sea and the Eastern Beaufort 
#' Sea of Canada. Coordinates are returned in the Lambert-Azimuthal Equal Area
#' Alaska Projection (epsg:3572).
#' 
#' @rdname extract_gshhg
#' @export
us_arctic <- function(xlims = c(180 - 2,180 + 50),
                      ylims = c(60,90), resolution = "i",
                      epsg = "3572", fortify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                fortify = fortify)
}

#' North Pacific Map Region
#' 
#' This map region covers the entire North Pacific Ocean from Hawaii in the
#' south to the Bering Sea in the north. Coordinates are returned in the PDC
#' Mercator Projection (epsg:3832)
#' 
#' @rdname extract_gshhg
#' @export
npac <- function(xlims = c(180 - 50,180 + 70),
                 ylims = c(20,67), resolution = "i",
                 epsg = "3832", fortify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                fortify = fortify)
}

#' California Current Map Region
#' 
#' This map region covers the California current off of the west coast of the 
#' United States. The region extends from southern British Columbia, Canada to
#' the Baja Peninsula of Mexico. Coordinates are returned in the California
#' (Teale) Albers Projection (epsg:3310).
#' 
#' @rdname extract_gshhg
#' @export
calcur <- function(xlims = c(180 + 35,180 + 70),
                   ylims = c(26,52), resolution = "i",
                   epsg = "3310", fortify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                fortify = fortify)
}