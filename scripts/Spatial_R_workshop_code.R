

## RStudio/Script setup -------------------------------------------

# Make a new project
# Put a folder named "data" in the project folder
# Download github data into that folder


# Load packages -------------------------------------------

library(tidyverse)           
library(sf)                 
library(mapview)             


# Import, project vector data -------------------------------------------

# Set path to data location (manual)
getwd()                             # Copy and paste this, add "/data" to the end 
fp <- "your_file_path/data"         # see above note

# Set path to data location (use relative file path: data is nested in project folder)
fp <- "data"                        # Because the working directory is the project folder, you can just use this

# Load the shapefile to object "watersheds" 
watersheds <- st_read(dsn = fp, "Tahoe_H12")      
watersheds                                      # Look at the geometry type, CRS, etc 
    


# Exploring simple features (vectors)  -------------------------------------------

# Check projection with the st_crs() function
st_crs(watersheds)              # Coordinate Reference Systems (EPSG, WKT--open source moving away from Proj4 strings)
                                # Spatialreference.org is your friend for looking up ESPG codes (and WKT and Proj4 encoding)


# Reproject to UTM (important to use projected coordinate systems if you want to deal with, for example, polygon area)
watersheds <- st_transform(watersheds, crs = 26910)   # NAD83 UTM Zone 10 (most of CA)


# Another look at sf object anatomy
watersheds # Dataframe = attribute table

class(watersheds)         # It's both class sf and dataframe
str(watersheds)           # Look at the data types (numeric, factor, sfc geometry list-column)


# Can examine columns individually just like they're a normal R dataframe
watersheds$Name                   # Factor (notice that "Levels" pops up under the output)
class(watersheds$Name)

watersheds$area_km2               # Numeric
class(watersheds$area_km2)
range(watersheds$area_km2)


# Subsetting data frames/sf objects --------------------------------------------------------

# Notice the difference in outputs between using indexing with the $ sign and subsetting with brackets 
watersheds$Name                       # "Name" column 
watersheds[,"Name"]                   # "Name"...and "geometry" columns (sticky geometries)
watersheds[1,]                        # First row of the dataframe
watersheds[,3]                        # Third column of the dataframe (still sticky)



# List-columns
class(watersheds$geometry)            # sfc = simple features collection
class(st_coordinates(watersheds))

st_coordinates(watersheds)
head(st_coordinates(watersheds))


#### Quick plot to get a visual check on what you have

# Basic plot 
plot(watersheds)
plot(st_geometry(watersheds))  
plot(watersheds$geometry)

# Sticky geometries mean you can plot one field at a time
plot(watersheds["HUType"])     # W = Waterbody, S = Standard, F = Frontal

# Quick interactive plot
mapview(watersheds)
mapview(watersheds, zcol = "HUType")   




#### Plot to get a visual of the `sf` object: baseplot function
plot(watersheds)                # Plots every attribute field
plot(st_geometry(watersheds))   # Plots just the vector geometry
plot(watersheds$geometry)       # Plots just the vector geometry (simpler)



plot(watersheds["HUType"])     # W = Waterbody, S = Standard, F = Frontal

mapview(watersheds)
mapview(watersheds, zcol = "HUType")   # Map colors to attribute col like we did with plot()


# SPATIAL OPERATIONS ------------------------------------------------------

# Load in streams layer
list.files(fp)
streams <- st_read(dsn = fp, "Tahoe_Streams")   # Huge, don't try to map it
streams


# Filter by attribute ------------------------------------------------------

# Let's just look at the streams in two of the northern watersheds
mapview(watersheds)                   # Use this to look up watershed IDs

ws_north <- watersheds[watersheds$ID == 99 | watersheds$ID == 100,]     # Filter using indexing
ws_north <- filter(watersheds, ID == 99 | ID == 100)    # Filter using the filter function

mapview(ws_north)                     # Quick check to make sure that did what we wanted


# Filter by location (not joining attributes) ---------------------------------

# Can filter by spatial indexing, too 
streams_north <- streams[ws_north,]                   # This will break         

st_crs(ws_north)    # What was the ESPG code again?
streams <- st_transform(streams, 26910)               # Reproject using ESPG code from watershed shapefile

streams_north <- streams[ws_north,]
mapview(streams_north)                                # Select by location but wihout needing to export


# Clip by polygon -----------------------------------------------------------

# Get rid of artificial paths going through lakes
streams_clean <- st_intersection(streams_north, ws_north)   # Clip rather than filter
mapview(streams_clean)




# RASTERS -----------------------------------------------------------------------------

library(raster)   

# Raster filepath setup is different than sf
fp                                                    # Should point to the data folder
fpr <- paste0(fp, "/nlcd_developed.tif")            # Raster filepath includes filename

# Raster package
nlcd_dev <- raster(fpr)                               # Load raster to object
mapview(nlcd_dev)                                     # mapview automatically drops resolution for easy viewing...by resampling a binary raster into a not-binary raster
unique(values(nlcd_dev))                              # But we can check our values and confirm that the raster is binary

plot(nlcd_dev)

# Extract raster to feature: which watershed is the most developed?

### Reproject polygons to match CRS of raster

# Check CRS
st_crs(watersheds)
st_crs(nlcd_dev)      # This is the sf function, and this is really cool. Notice the user input suggestions for 
                          #the sf object vs the raster object, which uses the same underlying projection syntax as sp objects!

# Reproject the vector (sf object)
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


# Convert the sp object back to an sf object
ws_dev_sf <- st_as_sf(ws_dev_sp)
ws_dev_sf


# Simplify your feature layer/sf object
ws_inputs <- select() # oh wait that says raster

ws_inputs <- dplyr::select(ws_dev_sf,                      # our starting object, and then the fields we want
                           ID,               
                           Area_km2,             
                           Name, 
                           Dev_pixels = nlcd_developed)  # you can rename fields in the same step
ws_inputs                                                  #sticky geometry came along for the ride, yay!

ws_inputs$Dev_km2 <- ws_inputs$Dev_pixels * 30^2/1000^2    # Multiply pixel count times pixel size in square km


# Again, what do we have
plot(ws_inputs["Dev_km2"])

# Get rid of the lake itself (not really a watershed)
ws_inputs <- ws_inputs[-5,]                               # Delete polygon by row index

# Better
plot(ws_inputs["Dev_km2"])


# EXPORTING SHAPEFILES AND CSV FILES --------------------------------------

# Create your output filepath
fpo <- paste0(getwd(), "/output")    # Alternative to copy and paste
fpo <- "output"                      # Or use the relative filepath


# This writes a shapefile b/c it's going to a folder; gdb feature, dsn = gdb
st_write(ws_inputs, dsn = fpo, "Tahoe_inputs_H12", overwrite = T, append = F, driver = "Esri Shapefile")  

# Writing out csv files

# Create a dataframe out of your sf object: two methods
ws_inputs_df <- st_drop_geometry(ws_inputs)        # Use a function to drop the geometry

ws_inputs_df <- ws_inputs                          # Can also rename the file and then get rid of the geometry col
ws_inputs_df$geometry <- NULL                      

write_csv(ws_inputs_df, paste0(fpo, "/Tahoe_inputs_H12.csv"))    # Write the csv to your output file




# MAKING MAPS ----------------------------------------------------------

# Interactive maps with mapview() --------------------------------------

mapview(ws_inputs, zcol = "Dev_km2")


# Make a list of basemaps, change default order
mapviewOptions() # copy basemaps list, paste

# Add other good ones, get rid of the ones showing up all gray in our area, re-order
basemaps <- c("Stamen.TonerLite", "OpenStreetMap", "Esri.WorldImagery",
"Esri.WorldTopoMap","Esri.WorldGrayCanvas")    

# Check the map
mapview(ws_inputs, zcol = "Dev_km2", map.types=basemaps)

# Change basemap list order to change which shows up first
basemaps2 <- c("Esri.WorldTopoMap", "Stamen.TonerLite", "OpenStreetMap", "Esri.WorldImagery",
"Esri.WorldGrayCanvas")   

# New map with updated legend label, re-ordered basemaps
mapview(ws_inputs, zcol = "Dev_km2", map.types=basemaps2, layer.name = "Tahoe Basin Development")
      # Can also do things like make fancy hover text, custom point markers, and other cool leaflet type things


# Static maps ---------------------------------------------

# Basic plot()
?plot                             # To view customizable options
plot(ws_inputs["Dev_km2"])
plot(ws_inputs["Dev_km2"], main = "Tahoe Basin Watersheds") # Legend could use some work, but it's not intuitive


# ggplot()  basic plot
ggplot(ws_inputs) +
  geom_sf()                 # Just like you'd call geom_points() or geom_lines()

# Add extra terms by including the + at the end of a line
ggplot(ws_inputs) +
  geom_sf() +                                  
  labs(x = "Longitude", y = "Latitude", title = "Tahoe Basin Watersheds")  # Same way to set labels

# Final map demonstrated 
ggplot(ws_inputs) +
  geom_sf(aes(fill = Dev_km2)) +                                                # Change color based on Dev_km2 field
  labs("Longitude", y ="Latitude", title = "Tahoe Basin Watersheds") +                
  scale_fill_viridis_c("Intensity-Weighted Area (km2)", option = "plasma") +    # Add legend title, change color ramp
  theme_bw()                                                                    # Add background theme

?ggplot                   

# Bonus Misc Useful Packages and Functions ----------------------------------------------------------

# To view a list of feature classes in a geodatabase without opening Arc/QGIS:
gdb <- "filepath/file.gdb"
rgdal::ogrListLayers(gdb)


# Static maps
    # You can make insert maps with ggplot() and the `cowplot` package (https://ryanpeek.org/mapping-in-R-workshop/vig_making_inset_maps.html#inset_maps)
    # `tmap` is a lot like ggplot(): similar structure, slightly more publication-friendly defaults (type in ??tmap). Also has interactive capabilities
    # `cartography` package has a lot of useful thematic map options (chloropleth maps, dot density maps, variouslegend options, classification (set raster cateogory breaks through various methods), etc (??cartography)
