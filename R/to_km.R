#' to_km
#'
#' convert tick labels in ggplot from meters to km. designed for use within 
#' the scale functions of ggplot2
#'
#' @author Josh M London
#' @export
to_km <- function(pos.only=FALSE) {
  if(pos.only){
    function(x) {
      ifelse(x>=0,as.character(x/1000),"")
    }
  }
  else {
    function(x) as.character(x/1000)
  } 
}