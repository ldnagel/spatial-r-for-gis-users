# Under construction, excuse the mess

# #maptimeDavis Presents: Spatial R for GIS Users

## Getting Started

* Make sure that you have up-to-date versions of R (≥ 3.3.0) and RStudio. For instructions on how to install R and RStudio for the first time, go [here](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/getting_started/Install-R-RStudio.md).
* Check your package versions: there have been some recent major overhauls of core spatial packages and some of the packages they depend on. [Here's a list of the package versions used in this workshop](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/getting_started/r-packages.md) and some package installation tips, we highly recommend installing these versions ahead of time to minimize troubleshooting during the workshop (unfortunately doing this remotely is going to limit the amount of troubleshooting we can do). If you're affiliated with UC Davis and are having trouble installing the software or R packages, [DataLab](https://datalab.ucdavis.edu/office-hours/) offers (virtual) drop-in hours Mondays 1:30-3pm PST.
* Data can be downloaded [in a zip file from this repo](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/data) or [here](https://ucdavis.box.com/s/gvw5r4jlh5nu21ie4zp5htn8ga5pn53o)
* The link to the livecode is [here](); there's also a script [here](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/scripts/Spatial_R_workshop_code.R) that you can download or copy/paste the contents directly from your browser (although it may be slightly different from the livecode)
  * Use the linked livecode and/or download the script on the repo as a source: copy/paste code if you're following along with the code and don't want to type it all out or missed something
  * If the livecoding appears to be lagging: First refresh the browser tab, and if that's not working message one of the meeting hosts in the chat to remind the speaker to save the livecode file again.



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
	title="Artwork by @allison_horst" width="500" />

Artwork by [@allisonhorst](https://github.com/allisonhorst)

* More details on the [history of GIS in R](https://edzer.github.io/UseR2017/#a-short-history-of-handling-spatial-data-in-r) (from 2017) 


## Resources

### Getting Started with R

* Detailed walkthrough: https://rspatial.org/pdf/Rintro.pdf
* Online book: [R for Data Science](http://r4ds.had.co.nz/), Grolemund and Wickham 2016
* Check out the Davis R Users Group (D-RUG) for [more resource links](http://d-rug.github.io/getting-started.html) and a [webinar archive](http://d-rug.github.io/pastpresentations/) ranging from intro concepts to advanced topics

### Spatial R Resources

* [Geocomputation with R](geocompr.robinlovelace.net), Lovelace et al 2020: Aimed at GIS users wanting to use R and vice versa
* [Using Spatial Data with R](https://cengel.github.io/R-spatial/intro.html), Engel 2019: Overview of spatial concepts using both `sf` and `sp` package systems
* [Tutorial](https://ryanpeek.org/mapping-in-R-workshop/vig_workflow_in_R_snowdata.html#spatial_data_and_r) using the `sf` package system
* [Tutorials](Rspatial.org) for spatial operations the `sp` package system, especially the `raster` package 


### Getting Help in R and/or with Spatial Issues

* Your favorite search engine is the best place to start--odds are good someone has had a similar issue, and it's often the easiest way to find information from forum archives such as [Stack Overflow](https://stackoverflow.com/search?q=%23R+%23spatial) or [blog](https://www.r-bloggers.com/) [posts](https://community.rstudio.com/categories)
* [Ask the D-RUG community](https://d-rug.discourse.group/)
* Spatial Sciences Research Cluster: come to the [#maptimeDavis](https://datalab.ucdavis.edu/spatial-sciences/) biweekly (virtual) discussion group
* [DataLab](https://datalab.ucdavis.edu/office-hours/) offers (virtual) drop-in hours Mondays 1:30-3pm PST
* UCD [geospatial listserv](https://lists.ucdavis.edu/sympa/info/geospatial)

