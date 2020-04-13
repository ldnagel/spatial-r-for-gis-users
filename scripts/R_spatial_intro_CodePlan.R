

# Make a new project

# Put data into project subfolder

# Load packages -------------------------------------------
library(tidyverse)
library(sf)
library(mapview)                # load them all up top (good coding practice) or as needed 
                                    # (make it clear when we're using which package?)
 

# Import, project vector data -------------------------------------------------

# Set filepath to folder containing the data, make sure you're using forward slashes
fp <- "C:/Users/Leah/Documents/Jobs/_CWS_Davis/Maptime/Intro_to_R_for_GIS_folks/data"

ws <- st_read(dsn = fp, "Tahoe_H12")    # Load the shapefile to object "ws" (watershed)
ws                                      # Go over what's there (simple feature, geom type, what CRS is, df structure)

# Projections 

# how to check projection

st_crs(ws)       # Coordinate Reference Systems (EPSG, WKT--open source moving away from Proj4 strings)
#spatialreference.org is your friend: can look up equivalents https://spatialreference.org/ref/epsg/26910/


# Useful EPSG codes 
# WGS 84                                 4326          # geographic
# NAD 83 UTM Zone 10 N (most of CA)      26910         # projected
# WGS 84 UTM Zone 10 N (most of CA)      32610


# Reproject
ws <- st_transform(ws, crs = 26910)



# Exploring simple features (vectors) -----------------------------------------------
class(ws)         # sf + dataframe
str(ws)           # Talk about data types (numeric, factor; also character, etc)...and geometry list-column


# Can examine columns individually
ws$Name                   # Factor (notice that "Levels" pops up under the output)
class(ws$Name)

ws$AreaSqKm               # Numeric
class(ws$AreaSqKm)
range(ws$AreaSqKm)


# Ways to subset data frames
ws$Name                       # "Name" column 
ws[,"Name"]                   # "Name"...and "geometry" columns (sticky geometries)
ws[1,]                        # First row of the dataframe
ws[,3]                        # Third column of the dataframe (still sticky)


# Get a visual
plot(ws)
plot(st_geometry(ws))  

# Sticky geometries mean you can plot one field at a time
plot(ws["HUType"])     # W = Waterbody, S = Standard, F = Frontal
# We'll come back to plotting later



# Spatial operations -------------------------------------------------------

list.files(fp)
streams <- st_read(dsn = fp, "Tahoe_Streams")   # Huge, don't try to map it
streams

# Let's aggregate by HUC 12 watershed--easier to work with, fewer lines
# How to get HUC12 ID? Spatial join
streams_12 <- st_intersection(streams, ws[,c("HUC12", "Name")])   
streams_12 <- st_intersection(st_zm(streams), ws[,c("HUC12", "Name")])   # Throws projection error

st_crs(ws)    # What was the ESPG code again?

# Rather than make a bunch of new files, we can do all of our reprojecting in one go
streams_12 <- st_transform(streams, 26910) %>% 
  st_intersection(ws[,c("HUC12", "Name")])           # flowlines have "m" dimension, throws error (Ryan--what's this?)

streams_12 <- st_transform(streams, 26910) %>% 
  st_zm() %>%                                     # Luckily it tells us how to fix it
  st_intersection(ws[,c("HUC12", "Name")])
streams_12                                        # Still have so many streamlines

# Total total length
streams_12 %>% 
  summarize(length_km = sum(LengthKM))

# Total length by subwatershed
streams_12 %>% 
  group_by(Name) %>% 
  summarize(length_km = sum(LengthKM))

strm_summ <- streams_12 %>% 
  group_by(Name) %>% 
  summarize(length_km = sum(LengthKM))
strm_summ$length_km


# introduce things like sorting by attributes?


# Buffer 
stm_buff <- st_buffer(strm_summ, 100)

st_area(stm_buff)



# Rasters ---------------------------------------------------------------------

library(stars)

ras <- "C:/Users/Leah/Documents/Jobs/_CWS_Davis/Maptime/Intro_to_R_for_GIS_folks/data/nlcd11_imp_tahoe.tif"

# Figure out stars workflow
nlcd_imp <- read_stars(ras) %>% 
  st_transform(st_crs(stm_buff))
tahoe_imp <- nlcd_imp[stm_buff]         # Results in a raster cropped to polygon
tahoe_imp <- aggregate(nlcd_imp, by = stm_buff, FUN = mean, na.rm = T)

# Raster package
nlcd_imp <- raster::raster(ras)
stm_imp <- raster::extract(nlcd_imp, as(stm_buff, "Spatial"), fun = mean, na.rm = T, df = T, sp = T)
stm_imp


# can do an attribute join to the original shapefile



# Writing out shapefiles ------------------------------------

#can have chains of objects and only write out one shapefile, much neater than creating a shp every step e.g.
   # watershed_clip -> watershed_clip_intersect.shp -> watershed_clip_intersect_2.shp

st_write(ws, dsn = "path-to-folder_path-to-gdb", "Name_NoExtension")  # To write a shapefile; gdb feature, dsn = gdb


# Static maps ---------------------------------------------

# ggplot/ggmap and/or tmap


# Interactive maps ---------------------------------------------

# basic mapview
# more complex mapview


# Misc very useful functions ---------------------------------

# To view a list of feature classes in a geodatabase without opening Arc/QGIS:
gdb <- "filepath/file.gdb"
rgdal::ogrListLayers(gdb)

# To use functions in a package that requires sp format rather than sf:
sp_object <- as(sf_object, "Spatial")

sf_object2 <- st_as_af(sp_object)      # And back again, if the result is another spatial object in sp


