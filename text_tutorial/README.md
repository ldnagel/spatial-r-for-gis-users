# Under construction, pardon the mess

## RStudio setup

* Make a new project in RStudio (select New Project from the File dropdown menu)
* Make a folder called "data" inside the project folder (using your file explorer)
* Download the data [here]()
  * Once you've downloaded and unzipped the file, copy and paste the files into the "data" folder
* Open a new script, save it in inside the project folder 

## Script setup

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

# Import, examine, and reproject vector data 

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

## Exploring simple features (vectors)

Anatomy of an sf object: 

* Geometry type
* Bounding box = layer extent
* CRS = Coordinate reference system, tells you the projection (more on that below)
* Dataframe (equivalent to an attribute table in a desktop GIS)

### Check Projection

``` r
st_crs(watersheds)
```

CRS = Coordinate Reference System

* `st_crs` displays ESPG code and WKT representation
* Open standards moving away from using Proj4 strings
* [spatialreference.org](https://spatialreference.org/ref/epsg/26910) is your friend
  * Use it to translate between ESPG, WKT, Proj4, etc 

Useful EPSG codes to know when working with California-based data

* Projected Systems
  - WGS 84                                 4326          
* Projected Systems
  - NAD 83 UTM Zone 10 N (most of CA)      26910       
  - WGS 84 UTM Zone 10 N (most of CA)      32610        

## Reproject sf object using `st_transform`

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

* Each feature (in this case, polygons) has a geometry type
  - You can mix points and polys in a single sf object
* Looks overwhelming at first until you get used to it
* Various functions give you easy access to the coordinates 
  - For example, if you have a point dataset and you want to put Easting into a single attribute field, use `st_coordinates` and isolate the Easting column

``` r
#watersheds$geometry
class(watersheds$geometry)            # sfc = simple features collection

#st_coordinates(watersheds)
class(st_coordinates(watersheds))     # matrices are similar to dataframes, easy to combine
```

## Plot to get a visual the `sf` object: baseplot function

``` r
# Get a visual
plot(watersheds)                # Plots every attribute field
plot(st_geometry(watersheds))   # Plots just the vector geometry
plot(watersheds$geometry)       # Plots just the vector geometry (simpler)
```

"Sticky geometries" allow you to plot one field at a time: as we saw above, when you index a single field using `dataframe["column_name"]`, the geometry column also comes along

```{r}
plot(watersheds["HUType"])     # W = Waterbody, S = Standard, F = Frontal

mapview(watersheds)
mapview(watersheds, zcol = "HUType")   # To display a field like we did with baseplot
```

We'll come back to mapping later




