
# R Studio anatomy and script basics ----------------------------------------

# This is the script pane

# To run code: 
#    1) Copy and paste code into the console (below by default), hit enter
#    2) Highlight the code you want to run and hit ctrl + enter


# Comments
# Putting "#" in a row will convert everything after it into a comment 
x <- 3     # Everything to the left of the pound sign will run in the console, but this text won't


# R Building Blocks ------------------------------------------------------------------

# Objects
x <- 3       # Create object x: Assign the value 3 to x using "<-"
y <- 4       # Assign the value 4 to the object y
x + y
x+y        # R is not whitespace sensitive
X + y      # R is case sensitive

a <- c(2, 4)      # Make a vector (1 dimensional, like a python array (?))
b <- c(8,16)
a
b
a+b
a+x

#Functions
sqrt(b)      #some functions are built in

read_csv()    # some functions come from packages (although this one is based on a base R fn)
?read_csv     # one of your best friends in figuring out how to use built in functions


# Data frames = tables ------------------------------------------

# Make a mini dataframe (a plain table)
df <- data.frame(ID = c(101,102,103), 
                 area = c(22.3, 54, 0.01), 
                 confidence = c("High", "Low", "High"),
                 trees = c(25, 10, 0))

# Print your dataframe in the console
df

# Open your dataframe in a new tab (can search, filter--a lot like a basic excel)
View(df)     

# Print the column/field names of your dataframe
names(df)

# Look at the structure of your object (your dataframe)
str(df)      # Tells you object class (data.frame), dimensions, field classes 

# Note that it automatically made the "confidence" column into a factor

# You can check field classes/data types directly
class(df$confidence)



# Data types -----------------------------------------------------------------------

df$ID                  # Numeric
df$confidence          # Factor (notice that "Levels" pops up under the output)   
class(df$confidence)
df$trees         
class(df$trees)   


# Changing data types

# Turn a numeric column into a text field (character strings)
as.character(df$ID) 

# Turn text into numbers
as.numeric(df$confidence)   
# Wait, what? Why did it let us do that?
class(df$confidence)    # Factors are stored as integers rather than strings



# Access different parts of the dataframe --------------------------------------

# Indexing by location in dataframe (think of it as x,y coordinates of cells)

# First row of the dataframe
df[1,]   

# Third column of the dataframe
df[,3]   

# Index by column name: two methods
df[,"confidence"]      
df$confidence         
# Effectively equivalent here, but when we get to spatial data they do slightly different things



# Subsetting data frames
df_high1 <- df[which(df$confidence == "High"),]    # Create new df: subest in base R
df_high1

df_high2 <- df %>% filter(confidence == "High")    # Create new df: Tidyverse syntax

# Tidyverse syntax (using the %>% pipes) lets you do multiple things in one code block
df %>%                                             
  filter(confidence == "High") %>% 
  arrange(area)






