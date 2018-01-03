#' Extract Region from GSHHG
#' 
#' Functions to extract specified N. Pacific regions from the GSHHG dataset
#'
#' @param xlims a vector of x coordinate limits; 0-360 degrees in most cases. When straddling 0, pass -longitude values (up to -180) for the left side.
#' @param ylims a vector of y coordinate limits: 0-90 degrees
#' @param resolution either "f", "h", "i", or "c"
#' @param epsg integer indicating the numeric epsg value (e.g. 3571)
#' @param simplify TRUE/FALSE whether to call rmapshaper::ms_simplify
#'
#' @return NULL
#' @export
#'
extract_gshhg <- function(xlims,ylims,
                          resolution = "i", 
                          epsg,
                          simplify = TRUE) {

  dir_path <- system.file("extData", package = "nPacMaps")
  file_name <- paste0("gshhs_",resolution,".b")
  gshhg_path <- paste(dir_path, "gshhg-bin-2.3.6", file_name, sep = "/")
  if(resolution %in% c("f","h")) {
    xlim_init <- xlims
    message("you requested either 'full' or 'high' resolution GSHHS data. It make take a few minutes to create your object")
  } else {xlim_init <- c(0,360)}
  
  this_extract <- PBSmapping::importGSHHS(gshhg_path,xlim = xlim_init, 
                                         ylim = ylims, n = 1,
                                         maxLevel = 1)
  if(!resolution %in% c("f","h")) {
    this_extract <- PBSmapping::refocusWorld(this_extract,xlim = xlims, ylim = ylims)
  }
  this_extract <- PBSmapping::clipPolys(this_extract,xlim = xlims, ylim = ylims)
  this_extract <- maptools::PolySet2SpatialPolygons(this_extract)
  this_extract <- sf::st_as_sf(this_extract) %>% sf::st_transform(epsg)
  
  if (simplify) {
    warning("nPacMaps now returns a polygon that has been simplified via the rmapshaper package. This should improve plotting performance. Set simplify = FALSE if you want to maintain the original gshhg shorelines.")
    
    this_extract <- rmapshaper::ms_simplify(this_extract,
                                            keep = 0.2,
                                            keep_shapes = TRUE,
                                            explode = TRUE)
  }
  return(this_extract)
}

#' Bering Sea Map Region
#' 
#' This map region is centered on the Bering Sea. Coordinates are returned in 
#' the Lambert-Azimuthal Equal Area Bering Sea Projection (epsg:3571)

#' @rdname extract_gshhg
#' @export
bering <- function(xlims = c(180 - 50,180 + 55),
                   ylims = c(35,80), resolution = "i",
                   epsg = 3571, simplify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                simplify = simplify)
}

#' Alaska Map Region
#' 
#' This map region covers the extent of Alaska. Coordinates are returned in the
#' Alaska Albers Projection (epsg:3338)
#' 
#' @rdname extract_gshhg
#' @export
alaska <- function(xlims = c(180 - 5,180 + 50),
                   ylims = c(35,68), resolution = "i",
                   epsg = 3338, simplify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                simplify = simplify)
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
                      epsg = 3572, simplify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,
                simplify = simplify)
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
                 epsg = 3832, simplify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg,simplify = simplify)
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
                   epsg = 3310, simplify = TRUE) {
  extract_gshhg(xlims = xlims,
                ylims = ylims, 
                resolution = resolution,
                epsg = epsg, simplify = simplify)
}