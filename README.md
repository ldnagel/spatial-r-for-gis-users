# Under construction, excuse the mess

# #maptimeDavis Presents: Spatial R for GIS Users

## Getting Started

* To install R and RStudio, go [here](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/Install-R-RStudio.md)
* Link to livecode is <here>
* Download data <here> 



## Why use R for GIS?

* Open source
* Reproducibility
* Scripting
* With packages, you can do...[just about anything you can think of](https://cran.r-project.org/web/views/Spatial.html)


### What (spatial things) can you do with R?

* Import and export spatial data
  * Common open source and proprietary formats (GeoJSON, ESRI shapefiles, etc)
  * Can handle a variety of projection formats (WKT, CRS, etc)

*  Interface directly with other programs (e.g. PostGIS, QGIS)

* Access spatial data in an efficient way
  * Directly access certain public datasets without going through not especially user-friendly portals (census data using tidycensus, National Hydrography Dataset using nhdplusTools, etc)

* Simple spatial functions
  * Intersect, buffer, extract 

* Advanced spatial analyses
  * Point pattern analysis 
  * Interpolation, cluster analysis, spatial autocorrelation tests, etc
  * Landscape metrics (FRAGSTATS)
  * Distribution modeling—puts spatial functions (extract raster data to points) and modeling (regression, Random Forest, etc) in one program

* Geometry cleaning 
  * e.g. detecting and fixing invalid geometries

* Mapping 
  * Generic and advanced functions used to produce figures in R can handle spatial data 
  * Packages designed to publication-friendly maps (tmap)
  * Interactive mapping: increasingly user-friendly packages to produce interactive maps ranging from quick views for data exploration to  complex, multi-layer maps built using R syntax (wrappers for leaflet, etc)
  * Digitization (mapedit provides an R shiny widget based on leaflet for editing or creating sf geometries) 



### Spatial Package Systems
•	sp: Spatial*Features (Spatial Points, Spatial Lines, etc)
o	Original system, <expand>
o	Structure (put in a picture)

•	sf: simple features 
o	OGC Simple Feature standard
o	Structure: focused around data frames





<img src="https://github.com/allisonhorst/stats-illustrations/blob/master/rstats-artwork/sf.png" 
	title="Artwork by @allison_horst" width="500" />



Artwork by [@allisonhorst](https://github.com/allisonhorst)






## Resources

### Getting Started with R

* Detailed walkthrough: https://rspatial.org/pdf/Rintro.pdf
* Online book: [R for Data Science](http://r4ds.had.co.nz/), Grolemund and Wickham 2016
* Interactive tutorial: DataCamp’s [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r)
* Check out the Davis R Users Group (D-RUG) for [more resource links](http://d-rug.github.io/getting-started.html) and a [webinar archive](http://d-rug.github.io/pastpresentations/) ranging from intro concepts to advanced topics

### Spatial R Resources

* [Geocomputation with R](geocompr.robinlovelace.net), Lovelace et al 2020: Aimed at GIS users wanting to use R and vice versa
* [Using Spatial Data with R](https://cengel.github.io/R-spatial/intro.html), Engel 2019: Overview of spatial concepts using both `sf` and `sp` package systems
* [Tutorial](https://ryanpeek.org/mapping-in-R-workshop/vig_workflow_in_R_snowdata.html#spatial_data_and_r) using the `sf` package system
* [Tutorials](Rspatial.org) for spatial operations the `sp` package system, especially the `raster` package 

<add more?>

### Getting Help in R and/or with Spatial Issues

* Your favorite search engine is the best place to start--odds are good someone has had a similar issue, and it's often the easiest way to find information from forum archives such as [Stack Overflow](https://stackoverflow.com/search?q=%23R+%23spatial) or [blog](https://www.r-bloggers.com/) [posts](https://community.rstudio.com/categories)
* [Ask the D-RUG community](https://d-rug.discourse.group/)
* [DataLab](https://datalab.ucdavis.edu/office-hours/) offers (virtual) drop-in hours Mondays 1:30-3pm PST
* [Spatial Sciences Research Cluster](https://datalab.ucdavis.edu/spatial-sciences/): #maptimeDavis biweekly (virtual) discussion group
* UCD [geospatial listserv](https://lists.ucdavis.edu/sympa/info/geospatial)

