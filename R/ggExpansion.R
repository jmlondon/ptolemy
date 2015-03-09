#' ggExpansion
#'
#' a functions for expanding the xlim and ylim ggplot values
#'
#' this allows the user to provide an expansion factor for xlim
#' and ylim values in ggplot
#'
#' @export
ggExpansion <- function(df,x=x,y=y,x_fac,y_fac,min_dist=10000) {
  x_rng <- range(df[x])
  y_rng <- range(df[y])
  
  x_dist <- diff(x_rng)
  y_dist <- diff(y_rng)
  
  if(x_dist < min_dist) {
    d <- min_dist-x_dist
    x_rng <- c(x_rng[1]-0.5*d, x_rng[2]+0.5*d)
    d <- min_dist-y_dist
    y_rng <- c(y_rng[1]-0.5*d, y_rng[2]+0.5*d)
    x_dist <- diff(x_rng)
    y_dist <- diff(y_rng)
  }
  
  x_exp <- x_dist*x_fac
  y_exp <- y_dist*y_fac
  
  limits <- list(xlim=c(x_rng[1]-0.5*x_exp,x_rng[2]+0.5*x_exp),
                 ylim=c(y_rng[1]-0.5*y_exp,y_rng[2]+0.5*y_exp))
  return(limits)
}