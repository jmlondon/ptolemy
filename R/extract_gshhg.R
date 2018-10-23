#' Extract Region from GSHHG
#' 
#' Functions to extract specified regions from the GSHHG dataset
#'
#' @param data an sf object that defines that area of interest
#' @param resolution either "f", "h", "i", or "c"
#' @param epsg integer indicating the numeric epsg value (e.g. 3571)
#' @param buffer integer indicating a value in projected units to buffer data
#' @param simplify TRUE/FALSE whether to call rmapshaper::ms_simplify
#'
#' @return NULL
#' @export
#'
extract_gshhg <- function(data,
                          resolution = "i", 
                          epsg = NULL,
                          buffer = 5000,
                          simplify = FALSE) {
  if (is.null(epsg)) {
    if (is.null(sf::st_crs(data))) {
      stop("epsg value not provided and cannot be determined from data")
    }
    if (sf::st_is_longlat(data)) {
      stop("data are in longlat and a projected epsg value is not provided")
    }
    epsg <- sf::st_crs(data)
  }
  dir_path <- system.file("extData", package = "nPacMaps")
  file_name <- paste0("gshhs_",resolution,".b")
  gshhg_path <- paste(dir_path, "gshhg-bin-2.3.7", file_name, sep = "/")
  
  data_buffer <- data %>% 
    sf::st_transform(epsg) %>% 
    sf::st_union() %>% 
    sf::st_convex_hull() %>% 
    sf::st_buffer(buffer) %>% sf::st_transform(4326)
  
  data_360 <- (sf::st_geometry(data_buffer) + c(360,90)) %% c(360) - c(0,90)

  bbox <- sf::st_bbox(data_360)
  xlim <- c(0,360)
  ylim <- c(bbox$ymin,bbox$ymax)
  
  this_extract <- PBSmapping::importGSHHS(gshhg_path,xlim = xlim, 
                                         ylim = ylim, n = 1,
                                         maxLevel = 1)
  xlim <- c(bbox$xmin,bbox$xmax)
  this_extract <- PBSmapping::refocusWorld(this_extract,xlim = xlim, ylim = ylim)
  this_extract <- PBSmapping::clipPolys(this_extract,xlim = xlim, ylim = ylim)
  this_extract <- maptools::PolySet2SpatialPolygons(this_extract)
  this_extract <- sf::st_as_sf(this_extract) %>% 
    sf::st_buffer(0) %>% 
    sf::st_transform(epsg)
  
  if (simplify) {
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
bering <- function(resolution = "i",
                   epsg = 3571,
                   simplify = FALSE) {
  extract_gshhg(data = ptolemy::bering_bbox, 
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
alaska <- function(resolution = "i",
                   epsg = 3338, simplify = FALSE) {
  extract_gshhg(data = ptolemy::alaska_bbox,
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
us_arctic <- function(resolution = "i",
                      epsg = 3572, simplify = FALSE) {
  extract_gshhg(data = ptolemy::us_arctic_bbox, 
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
npac <- function(resolution = "i",
                 epsg = 3832, simplify = FALSE) {
  extract_gshhg(data = ptolemy::npac_bbox, 
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
calcur <- function(resolution = "i",
                   epsg = 3310, simplify = FALSE) {
  extract_gshhg(data = ptolemy::calcur_bbox,
                resolution = resolution,
                epsg = epsg, simplify = simplify)
}