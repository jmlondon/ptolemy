#' fortifi
#'
#' a customized fortify function to optionally reduce detail when
#' plotting large shapefiles in ggplot
#'
#' @param poly SpatialPolygon. 
#' @param tol tolerance passed to the rgeos::gSimplify() function
#' @param minarea minimum area cutoff for printing a polygon
#' @return fortified poly as a data.frame ready for ggplot
#' @author Josh M London
#' @export
fortifi <- function(poly, tol, minarea=NA) {
  if (!requireNamespace("rgeos", quietly = TRUE)) {
    stop("rgeos needed for this function to work. Please install it.",
         call. = FALSE)
  }
  if(!is.na(minarea)) {
    poly<-poly[which(rgeos::gArea(poly,byid=TRUE)>minarea),]
  }
  poly<-rgeos::gSimplify(poly,tol=tol,topologyPreserve=TRUE)
  l<-length(poly)
  poly<-sp::SpatialPolygonsDataFrame(poly,data=data.frame(seq(1,l,1)),match.ID=FALSE)
  names(poly)[1]<-'region'
  slot(poly, "polygons") <- lapply(slot(poly, "polygons"), maptools::checkPolygonsHoles)
  poly<-ggplot2::fortify(poly)
  return(poly)
}