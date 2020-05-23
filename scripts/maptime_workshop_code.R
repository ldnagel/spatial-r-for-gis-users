
##### Livecode from Maptime Davis Virtual Workshop 28 April 2020 #####

# This code assumes you have already installed the following packages: 
   # tidyverse, sf, mapview, raster
   # If tidyverse won't install due to version issues, install and load the dplyr and readr packages

# Set up an RStudio project, download data from GitHub, and put files directly into 
   # a folder called "data" inside the project folder. If you end up with extra folders
   # due to the download process you may have to move the data files up a level or two

# Load packages   ----------------------------------------

library(tidyverse)    # or load readr and dplyr individually
library(sf)
library(mapview)

# Read in vector data ----------------------------------------

getwd()                        # Results in "your_file_path/RStudio_project_folder"

fp <- "your_file_path/RStudio_project_folder/data"
fp <- "data"                                         

# Read in the HUC 12 watershed shapefile, assign to sf object
watersheds <- st_read(dsn = fp, "Tahoe_H12")

# Check the file, note the spatial information and the attribute table
watersheds

# Check your projection (CRS = coordinate reference system)
st_crs(watersheds)

# If "user input" isn't 26910, reproject using `st_transform()`
watersheds <- st_transform(watersheds, crs = 26910)
st_crs(watersheds)


# Get more information about the sf object ----------------------------------------

class(watersheds)
str(watersheds)


# Access columns in an sf object
watersheds$Name              # Using "$" just targets the column itself
class(watersheds$Name)

watersheds$Area_km2
range(watersheds$Area_km2)


# Compare the outputs of the indexing methods
watersheds$Name
watersheds[,"Name"]       # Output is both "Name" field and geometry column
watersheds[,4]            # Output is both "Name" field (4th column) and geometry column

# What is the geometry column?
class(watersheds$geometry)
st_coordinates(watersheds)        # Converts list column into a matrix (easier to subset)


# Get a visual ----------------------------------------

# Plot all fields
plot(watersheds)

# Just plot vector geometry
plot(st_geometry(watersheds))
plot(watersheds$geometry)

# Plot geometry with field attributes
plot(watersheds["HUType"])

# Use mapview when you want to check attributes, pan and zoom
mapview(watersheds)
mapview(watersheds, zcol = "HUType")


# SPATIAL OPERATIONS ------------------------------------

list.files(fp)                  # Check which files are in your filepath

streams <- st_read(dsn = fp, "Tahoe_Streams")    # Read in streams shapefile
streams


# Filter by attribute ----------------------------------------

# Subset the watersheds object to just include the northern end: 3 methods
ws_north <- watersheds[watersheds$ID == 99 | watersheds$ID == 100,]  # Base R indexing

ws_north <- filter(watersheds, ID == 99 | ID == 100)     # dplyr filter function
ws_north <- watersheds %>%                               # dplyr filter function using pipes
  filter(ID == 99 | ID == 100)


# Check results
ws_north
mapview(ws_north)


# Filter by location ----------------------------------------

# Subset streams by watershed polygon locations
streams_north <- streams[ws_north,]             # this will break if projections don't match

# Check projections, reproject streams to match watersheds
st_crs(ws_north)                         
streams <- st_transform(streams, 26910)
streams_north <- streams[ws_north,]

# Check your output
mapview(streams_north)



# Clip by polygon ----------------------------------------

# Clip to watershed polygon boundaries
streams_clean <- st_intersection(streams_north, ws_north)
mapview(streams_clean)



# RASTERS ---------------------------------------------------------

library(raster)    # sp loads automatically, raster depends on sp

fp                                          # check your filepath

fpr <- "data/nlcd_developed.tif"            # filepath including raster filename
fpr <- paste0(fp, "/nlcd_developed.tif")    # filepath including raster filename

nlcd_dev <- raster(fpr)                     # load raster
mapview(nlcd_dev)                           # view raster (mapview resamples for viewing)

unique(values(nlcd_dev))                    # check values of raster (should be only 1, 0, NA)


# Extract raster to feature  ----------------------------------------

# Check projections
st_crs(watersheds)
st_crs(nlcd_dev)

# Reproject sf object to match raster
ws_albers <- st_transform(watersheds, st_crs(nlcd_dev))
st_crs(ws_albers)

# Convert sf object to sp (required for the raster package)
ws_sp <- as(ws_albers, "Spatial")


# Extract values
ws_dev_sp <- extract(nlcd_dev,       # raster
                     ws_sp,          # vector
                     fun = sum,      # add up amount of development
                     na.rm = TRUE,   # ignore NA values
                     df = TRUE,      # keep the dataframe
                     sp = TRUE)      # Add the new data to the sp object
ws_dev_sp


# Post-Extraction Data Wrangling  ----------------------------------------

# Convert back to sf object
ws_dev_sf <- st_as_sf(ws_dev_sp)
ws_dev_sf

# Create a new, simplified sf object
ws_inputs <- dplyr::select(ws_dev_sf, ID, Area_km2, Name, Dev_pixels = nlcd_developed)
ws_inputs

# Create a new field that represents development area rather than pixel count
ws_inputs$Dev_km2 <- ws_inputs$Dev_pixels * 30^2/1000^2

# Plot the results
plot(ws_inputs["Dev_km2"])

# Get rid of polygon by indexing (in this case, the lake itself)
ws_inputs <- ws_inputs[-5,]

# Plot the results
plot(ws_inputs["Dev_km2"])


# Writing out shapefiles  --------------------------------------------

# Create a new filepath (keep your output separate from your raw data)
fpo <- "output"

# Write out the shapefile
st_write(ws_inputs, dsn= fpo, "Tahoe_inputs_H12", 
         overwrite = TRUE, append = FALSE, driver = "Esri Shapefile")

# To convert sf objects to dataframes:
ws_inputs_df <- st_drop_geometry(ws_inputs)

# Write out the csv
write_csv(ws_inputs_df, paste0(fpo, "/Tahoe_inputs_H12.csv"))
