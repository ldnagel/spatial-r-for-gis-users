# Under construction, pardon the mess

* [Setup](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/text_tutorial/README.md#setup)
* [Working with vector data](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/text_tutorial/README.md#working-with-vector-data)
  - [Reproject vector layer](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#reproject-vector-layer)
  - [Explore attribute table](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#explore-the-attribute-table)
  - [Quick plots](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#plot-to-get-a-visual-the-sf-object-baseplot-function)
  - [Spatial operations](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#spatial-operations)
* [Working with raster data](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#rasters)
  - [Extract raster to features](https://github.com/ldnagel/spatial-r-for-gis-users/tree/master/text_tutorial#extract-raster-to-feature)
  - [Converting and modifying resulting feature layers]()
* [A quick peek at mapping in R]()

## Setup

RStudio setup

* Make a new project in RStudio (select New Project from the File dropdown menu)
* Make a folder called "data" inside the project folder (using your file explorer)
* Download the data [here]()
  * Once you've downloaded and unzipped the file, copy and paste the files into the "data" folder
* Open a new script, save it in inside the project folder 

Script setup

Packages are like plugins--install and load to get increase functionality (or at least more functions). In order to use functions in a package, we need to load the package library

* Installing packages: only happens once
* Loading packages via the `library()` function: happens every time you run a script

### Use the `library()` function to load packages

Check out the packages pane over on the right (pre- and post-library load)

#### The Tidyverse: a system of packages with shared "grammar" 

* A lot of Tidyverse packages have functions that are very very useful for data manipulation. 
* `tidyverse` the package is a way to load about ten of them at the same time. 
* Look over at the console: it told me which packages it's loading

``` r
library(tidyverse)
```

* Conflict messages warn you when two packages have functions with the same name
  - E.g. if you use `filter()` it's going to use the `dplyr` version of the function and not the `stats` version
* If you're getting an error about `xml` when installing the `tidyverse` package, just install/load `dplyr` and `readr` (likely only a temporary issue caused by `tidyverse` conflicts with the new R version)

#### The `sf` package and the Tidyverse

``` r
library(sf)
```

The `sf` package is part of the Tidyverse

* A lot of the Tidyverse data manipulation functions work on `sf` too
* `sf` does not load as part of the `tidyverse` package, so we have to load it separately


####  Use the `mapview` package for interactive maps

``` r
library(mapview)                 
```

* Mapview is great for quick checks of your data (you can pan and zoom like graphical GIS systems/google maps)
* You can also use it to create customized interactive maps that you can then share/post online

# Working with vector data 

## Import and examine vector layer

Use the function `getwd()` to check the default filepath (should be the RStudio project folder)

To navigate to the "data" folder in the project folder:

``` r
fp <- "data" 
fp <- paste0(getwd(), "/data")         # pastes "/data" onto the end of the `getwd()` output
fp <- paste0(here::here(), "/data")    # here() points to the project directory even in .Rmd
```

Load the shapefile to object `watersheds` and check the output

``` r
watersheds <- st_read(dsn = fp, "Tahoe_H12")     
watersheds                                        
```

### Exploring simple feature objects (vectors imported using `sf`)

Anatomy of an sf object: 

* Geometry type
* Bounding box = layer extent
* CRS = Coordinate reference system, tells you the projection (more on that below)
* Dataframe (equivalent to an attribute table in a desktop GIS)

## Reproject vector layer

Check initial projection

``` r
st_crs(watersheds)
```

CRS = Coordinate Reference System

* `st_crs` displays ESPG code and WKT representation
* Open standards moving away from using Proj4 strings
* [spatialreference.org](https://spatialreference.org/ref/epsg/26910) is your friend
  - Use it to translate between ESPG, WKT, Proj4, etc 

Useful EPSG codes to know when working with California-based data

* Projected Systems
  - WGS 84                                 4326          
* Projected Systems
  - NAD 83 UTM Zone 10 N (most of CA)      26910       
  - WGS 84 UTM Zone 10 N (most of CA)      32610        

### Reproject sf object using `st_transform`

``` r
watersheds <- st_transform(watersheds, crs = 26910)
st_crs(watersheds)
```

## Explore the attribute table

``` r
class(watersheds)         
str(watersheds)       
```

### Accessing individual columns

With sf objects we can explore individual columns as we would a regular dataframe in R (with a few differences)

``` r
watersheds$Name                   # Factor (notice that "Levels" pops up under the output)
class(watersheds$Name)

watersheds$Area_km2               # Numeric
class(watersheds$Area_km2)
```

Run each of these commands individually to compare the differences

``` r
watersheds$Name                       # "Name" column 
watersheds[,"Name"]                   # "Name" column plus "geometry" columns (sticky geometries)
watersheds[1,]                        # First row of the dataframe 
watersheds[,3]                        # Third column of the dataframe (still sticky)
```

### Handling list-columns

Each feature (in this case, polygons) has a geometry type
* You can mix points and polys in a single sf object
* List columns can look overwhelming at first until you get used to the format

``` r
watersheds$geometry
class(watersheds$geometry)            # sfc = simple features collection
```

Various functions give you easy access to the coordinates 
* For example, if you have a point dataset and you want to put Easting into a single attribute field, use `st_coordinates` and isolate the Easting column

``` r
st_coordinates(watersheds)
class(st_coordinates(watersheds))     # matrices are similar to dataframes, easy to combine
```

## Plot to get a visual the `sf` object: baseplot function

``` r
plot(watersheds)                # Plots every attribute field
```

# [insert plot image here]

``` r
plot(st_geometry(watersheds))   # Plots just the vector geometry
```

# [insert plot image here]

``` r
plot(watersheds$geometry)       # Plots just the vector geometry (simpler)
```

# [insert plot image here]

"Sticky geometries" allow you to plot one field at a time: as we saw above, when you index a single field using `dataframe["column_name"]`, the geometry column also comes along

``` r
plot(watersheds["HUType"])     # W = Waterbody, S = Standard, F = Frontal
```

# [insert screenshot here]


``` r
mapview(watersheds)
```

# [insert screenshot here]

``` r
mapview(watersheds, zcol = "HUType")   # To display a field like we did with baseplot
```

We'll come back to mapping later


# Spatial Operations

Load in streams layer

``` r
list.files(fp)                                  # Check the filenames
streams <- st_read(dsn = fp, "Tahoe_Streams")   # Huge, don't try to map it
streams
```

### Filter by attribute

Let's just look at the streams in two of the northern watersheds

``` r
mapview(watersheds)    # Hover over the polygons to get watershed ID
```

# [insert screenshot here]

``` r
ws_north <- watersheds[watersheds$ID == 99 | watersheds$ID == 100,]     # Filter using indexing
ws_north <- filter(watersheds, ID == 99 | ID == 100)                    # Filter using the filter function
```

Use `mapview()` or `plot()` to do a quick visual check

``` r
mapview(ws_north)                  # quick check to make sure that did what I thought it did
```

# [insert screenshot here]

### Filter by location (not joining attributes)

Equivalent to exporting the results of a "Select by Location" operation in ArcGIS

``` r
streams_north <- streams[ws_north,]          # Can filter with indexing spatially, too
```

`sf` won't let us do spatial operations when polys are in different projections

``` r
st_crs(ws_north)                            # Look up the ESPG code for the other shapefile
streams <- st_transform(streams, 26910)

# Filter by location
streams_north <- streams[ws_north,]
```

Check the new sf object

``` r
mapview(streams_north)                     
```

You can make many intermediate objects without needing to export/create new files until the end

### Clip by polygon border

Get rid of artificial paths going through lakes: clip rather than filter

``` r
streams_clean <- st_intersection(streams_north, ws_north)   
mapview(streams_clean)
```

# [insert screenshot here]


# Rasters

One of the major ways we think about land and water interacting on the aquatic side is terrestrial inputs into aquatic systems such as nutrients and sediments. 

The amount of nutrients and sediments entering waterbodies is influenced by land cover type. Agriculture and development (from lawns to cities) tend to increase the amount of nutrients and sediments entering these systems, which can change the dynamics in aquatic systems (even a lake as big and deep as Tahoe). 

In the case of Tahoe, which is ringed by mountains, most of what's going into the lake either from streams or direct overland runoff is going to come from the area immediately surrounding the lake.  

In order to see what land cover--forest, developed areas, wetlands, etc--is surrounding the lake, we can use the National Land Cover Database, which (as you might guess from the name) is a dataset that has landcover data for the entire US. The raster we're using here only includes pixels from the full dataset classified as "developed" (a category that can range from light development such as lawns to highly urbanized). 

``` r
library(raster)   
```


### Reading in a raster using `raster::raster()`

The filepath setup for `raster()` is slightly different than `sf()`. Either copy and paste path to the data folder and manually add filename, or use the `paste0()` function to do it automatically

``` r
fp                                         # Filepath to the data folder    
fpr <- paste0(fp, "/nlcd_developed.tif")   # Raster filepath includes filename of raster
```

Load the raster into R using the `raster` package

``` r
nlcd_dev <- raster(fpr)                      # Load raster to object
mapview(nlcd_dev)                            # Mapview resamples raster to reduce resolution
```

# [insert screenshot here]

This should be a binary raster--why are there multiple values (see the edges of the blocks of developed blocks). Mapview resamples the raster to reduce the resolution so the data displays quickly. 

Check the raster values to ensure that the raster object is what you think it is:

``` r
unique(values(nlcd_dev))                     # Check values: yep, still binary
```

## Extract raster to feature

Let's look at which watersheds are the most developed 

### Reproject polygons to match CRS of raster

This time, let's check our projections beforehand. Notice the difference between the output for `st_crs()`: some projections are specific enough that they still use proj4 strings. 

``` r
st_crs(watersheds)
st_crs(nlcd_dev)      
```

Having the proj4 string is useful if you want to use raster functions to handle projections. In this case, we do not--it's better transform shapefiles than rasters 
* Much faster 
* Doesn't require resampling the raster, which can result in data loss

``` r
ws_albers <- st_transform(watersheds, st_crs(nlcd_dev)) 

# Raster was built as part of the sp system, so we need to convert for the extraction
ws_sp <- as(ws_albers, "Spatial")


ws_dev_sp <- extract(nlcd_dev,      # raster 
                     ws_sp,         # polygons to extract raster values to
                     fun = sum,     # add up the amount of impervious surface
                     na.rm = TRUE,  # when summing values, ignore missing values
                     df = TRUE,     # keep the dataframe associated with the sp object/feature layer
                     sp = TRUE)     # add the extracted values to the input sp object/feature layer
ws_dev_sp  
```

## Converting and modifying feature layers

### Convert the sp object back to an sf object

``` r
ws_dev_sf <- st_as_sf(ws_dev_sp)
ws_dev_sf
```

### Modify and simplify sf objects

Simplify the attribute table

``` r
ws_inputs <- select()                    # Oh wait, it's the raster function
```

As you type in `select()`, RStudio tells you which package the function comes from. In this case, we don't want the `raster` version of select, we want the `dplyr` function. We can tell R to do this by specifying the package and function at the same time using `::` syntax. 

``` r
ws_inputs <- dplyr::select(ws_dev_sf,                      # our starting object, and then the fields we want
                           ID,               
                           Area_km2,             
                           Name, 
                           Dev_pixels = nlcd_developed)    # You can rename fields in the same step
ws_inputs                                                  # Sticky geometry came along for the ride, hooray!
```

Our extraction process produced a pixel count--let's convert that to area. 

``` r
ws_inputs$Dev_km2 <- ws_inputs$Dev_pixels * 30^2/1000^2    # Pixel count * pixel size in square km
```

What have we created? 

``` r
plot(ws_inputs["Dev_km2"])
```

# [insert screenshot here]

There isn't really development in the lake, let's take it out of there.

``` r
ws_inputs <- ws_inputs[-5,]     # Delete by row index
```

# [insert screenshot here]

That's better.

``` r
plot(ws_inputs["Dev_km2"])
```

# [insert screenshot here]




