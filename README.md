# Spatial R for GIS Users

## Tutorials

* Text-based tutorial is [here](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial)
* [Tutorial with code and video walkthrough](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/maptime_webinar): Recording of a (virtual) #MaptimeDavis Workshop (April 2020)

## Why use R for GIS?

* Open source
  * Free to use, transferable
  * Transparent analyses 
* Scripting
  * Automate repeated tasks
  * Increase research reproducibility
* Integrated workflow 
  * Similar syntax to other R packages
  * Keeps all of your spatial and non-spatial analyses in one program/workflow 


### What (spatial things) can you do with R?

CRAN Task Pages: topic-specific [lists of packages](https://cran.r-project.org/web/views/Spatial.html). From the Spatial page (condensed):

* Import and export spatial data
  * Common open source and proprietary formats (GeoJSON, ESRI shapefiles, etc)
  * Can handle a variety of projection formats (WKT, CRS, etc)

* Interface directly with other programs
  * PostGIS, QGIS, others

* Access spatial data in an efficient way
  * Directly access certain public datasets without going through not especially user-friendly portals (census data using `tidycensus`, National Hydrography Dataset using `nhdplusTools`, etc)

* Simple spatial functions
  * Intersect, buffer, extract 

* Advanced spatial analyses
  * Point pattern analysis 
  * Interpolation, cluster analysis, spatial autocorrelation tests, etc
  * Landscape metrics (FRAGSTATS-type functionality)
  * Distribution modeling—puts spatial functions (extract raster data to points) and modeling (regression, Random Forest, etc) in one program

* Geometry cleaning 
  * Detecting and fixing invalid geometries

* Mapping 
  * Generic and advanced functions used to produce figures in R can handle spatial data 
  * Packages designed to publication-friendly maps
  * Interactive mapping: increasingly user-friendly packages to produce interactive maps ranging from quick views for data exploration to  complex, multi-layer maps built using R syntax (wrappers for leaflet, etc)
  * Digitization 


## Spatial Package Systems in R

Two core spatial packages in R:

* `sp`: Spatial\*Features (Spatial Points, Spatial Lines, etc)
  * Original framework for handling spatial data in R (first version released in 2004)
  * Most packages for analyzing and mapping spatial data built before 2016 depend on this package
  * Data structure can make it complicated to access attribute data for analysis spatial data

* `sf`: simple features 
  * New framework for handling spatial data in R (first released in 2016, intended to eventually replace sp)
  * Adheres to [Open Geospatial Consortium](https://www.osgeo.org/partners/ogc/) Simple Features standard
  * Vector data structure focused around data frames (more intuitive for users familiar with common data manipulation workflows in R)

<img src="https://github.com/allisonhorst/stats-illustrations/blob/master/rstats-artwork/sf.png" 
	title="Illustration entitled 's f: spatial data...simplified' depicting colorful fluffy critters taping shapes to an attribute table into a column labeled 'geometries' (and also onto themselves) with the caption 'sticky geometries, for people who love their maps (and sanity)'" width="500" />

A great (and adorable) visual of how the sf package handles vectors: an attribute table with geometries (points, polygons, etc) that 'stick' to each row/feature. Artwork by [@allisonhorst](https://github.com/allisonhorst). 

* More details on the [history of GIS in R](https://edzer.github.io/UseR2017/#a-short-history-of-handling-spatial-data-in-r) (from 2017) 


## Resources

Note: some of these are UC Davis-specific, but most are widely available

### Getting Started with R

* Detailed walkthrough: https://rspatial.org/pdf/Rintro.pdf
* Online book: [R for Data Science](http://r4ds.had.co.nz/), Grolemund and Wickham 2016
* Check out the Davis R Users Group (D-RUG) for [more resource links](http://d-rug.github.io/getting-started.html) and a [webinar archive](http://d-rug.github.io/pastpresentations/) ranging from intro concepts to advanced topics

### Spatial R Resources

* [Geocomputation with R](https://geocompr.robinlovelace.net), Lovelace et al 2020: Aimed at GIS users wanting to use R and vice versa
* [Using Spatial Data with R](https://cengel.github.io/R-spatial/intro.html), Engel 2019: Overview of spatial concepts using both `sf` and `sp` package systems
* [Tutorial](https://ryanpeek.org/mapping-in-R-workshop/vig_workflow_in_R_snowdata.html#spatial_data_and_r) using the `sf` package system
* [Tutorials](https://Rspatial.org) for spatial operations the `sp` package system, especially the `raster` package 


### Getting Help in R and/or with Spatial Issues

* Your favorite search engine is the best place to start--odds are good someone has had a similar issue, and it's often the easiest way to find information from forum archives such as [Stack Overflow](https://stackoverflow.com/search?q=%23R+%23spatial) or [blog](https://www.r-bloggers.com/) [posts](https://community.rstudio.com/categories)
* [Ask the D-RUG community](https://d-rug.discourse.group/)
* Spatial Sciences Research Cluster: come to the [#maptimeDavis](https://datalab.ucdavis.edu/spatial-sciences/) biweekly (virtual) discussion group
* [DataLab](https://datalab.ucdavis.edu/office-hours/) offers (virtual) drop-in hours Mondays 1:30-3pm PST
* UCD [geospatial listserv](https://lists.ucdavis.edu/sympa/info/geospatial)

