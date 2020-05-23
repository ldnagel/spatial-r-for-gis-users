
## Package versions used in this workshop

R version 3.6 (`sf 0.9-0` requires a minimum of R 3.3.0)

`sf` version 0.9-0 (ignore messages about version 0.9-2 available from source)

`tidyverse` 1.3.0
* `dplyr` version 0.8.5 (1.0.0 not yet out)
* `readr` 1.3.1 
* `ggplot2` 3.3.0

`mapview` 2.7.8

`sp` 1.4-1

`raster` 3.0-12

## Notes/Disclaimer on Workshop Timing

This workshop is being developed and presented during an odd moment in time in the R world
1. There is an ongoing major overhaul in the `sf` package (most of the basic functionality is working at this point, but old code using the package or packages that depend on it may break, and not all packages that depend on `sf` have finished updating in response).
2. The `dplyr` package (very useful for manipulating spatial data based on attributes) is also undergoing a major overhaul, and will be released a few weeks after this workshop (April 2020). This repository may or may not get updated after that release, so if you find this workshop in the future that may or may not be an issue.
3. R had a major update immediately prior to this workshop; the livecode used version 3.6. The only apparent conflict that arose with 4.0 and the packages mentioned above was with the `tidyverse` package; If you're running 4.0 and an error when installing `tidyverse`, try installing and loading `dplyr`, `readr`, and `ggplot2` individually (note the versions listed above). 
 
## Installing packages in R/RStudio

  * In the console (default location is lower left corner): type install.packages("package_name")
 
 ![New RStudio window](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/getting_started/img/RStudio_install_pkg_code.PNG)

 OR
 
  * In the Packages tab (default location is lower right quadrant of RStudio): 
    * Install from Repository (CRAN) (default)
    * Type package name(s) in the box
    * Install to Library (leave the [Default] path in place if you've never done this before)
    * Leave Install dependencies checked

![New RStudio window](https://github.com/ldnagel/spatial-r-for-gis-users/blob/master/getting_started/img/RStudio_install_pkg_gui.PNG)

If packages have installed correctly, the text "package 'package-name' successfully unpacked and MD5 sums checked" will display in the console along with the filepath to where R put the downloaded binary packages.



