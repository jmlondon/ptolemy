
<!-- README.md is generated from README.Rmd. Please edit that file -->
nPacMaps: an R package for North Pacific basemap data
=====================================================

About
-----

executive summary of the package and functions

Installation
------------

The nPacMaps package is not available on CRAN and must be installed via the `devtools::install_github()` function.

``` r
install.packages("devtools")
devtools::install_github('jmlondon/npacmaps',ref='develop')
```

After successfully installing the package from GitHub, you will need to download and install the GSHGG data. This is handled via the `nPacMaps::install_gshhg()` function.

``` r
library(nPacMaps)
install_gshhg()
```

Examples
--------

### North Pacific Basemap

``` r
library(ggplot2)
library(nPacMaps)
#> Loading required package: maptools
#> Loading required package: sp
#> Checking rgeos availability: TRUE
#> nPacMaps 2.0 (2016-07-05) 
#>  The nPacMaps package requires an additional installation step.
#>  Please type 'install_gshhg()' to complete this install.

npac_base <- nPacMaps::npac()
#> Data are polygon data
#> Rgshhs: clipping 7 of 2251 polygons ...

npac_plot <- ggplot() + 
  geom_polygon(data = npac_base,
               aes(x = long,y = lat,group = group,id = id),
               fill = "grey60") +
  coord_fixed() +
  xlab("easting (km)") + ylab("northing (km)") +
  scale_x_continuous(labels = nPacMaps::to_km()) +
  scale_y_continuous(labels = nPacMaps::to_km())
npac_plot
```

![](README-npac-example-1.png)

### Alaska Basemap

``` r
library(ggplot2)
library(nPacMaps)

ak_base <- nPacMaps::alaska()
#> Data are polygon data
#> Rgshhs: clipping 5 of 6791 polygons ...

ak_plot <- ggplot() + 
  geom_polygon(data = ak_base,
               aes(x = long,y = lat,group = group,id = id),
               fill = "grey60") +
  coord_fixed() +
  xlab("easting (km)") + ylab("northing (km)") +
  scale_x_continuous(labels = nPacMaps::to_km()) +
  scale_y_continuous(labels = nPacMaps::to_km())
ak_plot
```

![](README-ak-example-1.png)

We can also zoom in on a particular region

``` r
library(ggplot2)
library(nPacMaps)
library(crawl)
#> crawl 2.0 (2016-02-24) 
#>  Type 'vignette('crawl_intro')' to see examples of package use, and
#>  'demo(package='crawl')' will provide a list of demos.
#>  The raw code for the demos can be found by typing:
#>  'system.file('demo', package='crawl')'
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

data("harborSeal")

harborSeal <- harborSeal %>% filter(!is.na(latitude)) %>% 
  as.data.frame()

sp::coordinates(harborSeal) <- ~longitude + latitude
sp::proj4string(harborSeal) <- CRS("+init=epsg:4326")

harborSeal <- sp::spTransform(harborSeal, CRS("+init=epsg:3338"))
harborSeal <- as.data.frame(harborSeal)

map_limits <- nPacMaps::ggExpansion(harborSeal,x = "longitude",y = "latitude",
                                    x_fac = 0.25, y_fac = 0.25)

ak_base <- nPacMaps::alaska()
#> Data are polygon data
#> Rgshhs: clipping 5 of 6791 polygons ...

ak_plot <- ggplot() + 
  geom_polygon(data = ak_base,
               aes(x = long,y = lat,group = group,id = id),
               fill = "grey60") +
  geom_point(data = harborSeal,aes(x = longitude, y = latitude), 
             alpha = 0.1, color = 'blue') +
  coord_fixed(xlim = map_limits$xlim, ylim = map_limits$ylim) +
  xlab("easting (km)") + ylab("northing (km)") +
  scale_x_continuous(labels = nPacMaps::to_km()) +
  scale_y_continuous(labels = nPacMaps::to_km())
ak_plot
```

![](README-ak-example-zoom-1.png)
