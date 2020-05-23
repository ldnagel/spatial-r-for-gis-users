

## RStudio/Script setup -------------------------------------------

# This code assumes you have already run through the video tutorial/the code here: https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/scripts/maptime_workshop_code.R
# You should have created written out the layer "Tahoe_inputs_H12" to a folder named "output"
# The output folder should be in your RStudio project directory

# Load packages -------------------------------------------

library(readr)          
library(ggplot2)
library(sf)                 
library(mapview)             

# Set path to data location (use relative file path: data is nested in project folder)
fp <- "output"                        # Because the working directory is the project folder, you can just use this

# Load the shapefile to object "ws_inputs" 
ws_inputs <- st_read(dsn = fp, "Tahoe_inputs_H12")      
ws_inputs                                      # Look at the geometry type, CRS, etc 
  

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
    # `tmap` is a lot like ggplot(): similar structure, slightly more publication-friendly defaults (type ?tmap::tmap in the console). Also has interactive capabilities
    # `cartography` package has a lot of useful thematic map options (chloropleth maps, dot density maps, variouslegend options, classification (set raster cateogory breaks through various methods), etc
