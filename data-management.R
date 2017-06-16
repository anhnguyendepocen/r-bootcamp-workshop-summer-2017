## 2. Data Exploration with R - Basics

# - [World Bank data] is used for R Bootcamp (http://data.worldbank.org/)
# - For data manipulation, we Mainly use "dplyr" package
# - "dplyr" [Cheat Sheet] offers good guides
# - (https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
















### ----------
### 1) Installing and Loading Package

# - Package is a set of functions developed for specific purposes
# - e.g., "igraph" is used for network analysis, "haven" is used for importing other forms of datasets, "ggplot2" is used for data visualization
# - You can install packages from CRAN repository by web

install.packages("dplyr")
install.packages("haven")
install.packages("tidyverse")

# - You can load packages by "library"-ing it
library("dplyr")
library("haven")
library("tidyverse")

# - Note: ["tidyverse"](http://tidyverse.org/) is a "combination" package for popular packages










### ----------
### 2) Setting Working Directory

# - Setting working directory makes you reach to files easily
# - Working directory is directory where you work with your files
# - It makes a shortcut to them

getwd() ## print the current working directory
setwd("C:/R Bootcamp") ## set up working directory
# setwd("~/R Bootcamp") ## For Mac & Linux
# setwd("/R Bootcamp") ## For Linux

getwd() ## print the (new) current working directory

## Warning: In R Markdown, working directory is the directory of the R Markdown file.
## You do not have to set up working directory if you use R Markdown.











### ----------
### 3) Importing data

# - Import World Bank data (customized for today)
# - Population, GDP, health expenditure, land area, mortality rate...

# - Import csv file
d.POP <- read.csv("Data/WB_pop_total.csv")

# - read_dta: "haven" function to load STATA dta file
library("haven") ## "haven" is a part of "tidyverse"
d.POP.1 <- read_dta("Data/WB_pop_total.dta")

### Practice 1: Import other csv data files from the "data" folder
d.GDP <- read.csv("Data/WB_gdp.csv", header = T, stringsAsFactors = F)
d.HEX <- read.csv("Data/WB_healthexp.csv", header = T, stringsAsFactors = F)
d.LAN <- read.csv("Data/WB_landarea.csv", header = T, stringsAsFactors = F)
d.MOR <- read.csv("Data/WB_mortality.csv", header = T, stringsAsFactors = F)

## "header = T" means it will read the first row as column name
## "stringAsFactors = F" means it will consider columns with characters as "characters",
## not categories

## POP: Population, total
## GDP: GDP (Current $)
## HEX: % of health expenditure to total GDP (%)
## LAN: Land area (sq. km)
## MOR: Mortality rate (per 1000 lives birth)





### ----------
### 4) Reshaping data
# - If you look d.POP, you can see each variable means population of each year
# - We would like to build "year" column, and stack the records by year
# - This job is called "reshaping" wide data to long data

# - Wide to long: "gather"
dd1 <- gather(d.POP, "year", "POP", 4:18)

dd2 <- d.POP %>% gather("year", "POP", 4:18) ## With "Pipelining", "%>%"

d.POP.L <- d.POP %>%
  gather("year", "POP", 4:18) ## Restoring reshaped data as "d.POP.L"

# - Long to wide: "spread"
d.POP.W <- spread(d.POP.L, year, POP)

d.POP.W <- d.POP.L %>%
  spread(year, POP)

rm(dd1, dd2, d.POP.W) # remove object "dd1", "dd2", "d.POP.W"

### Practice 2: Reshape the raw data from wide to long
d.GDP.L <- d.GDP %>% gather("year", "GDP", 4:18)
d.HEX.L <- d.HEX %>% gather("year", "HEX", 4:18)
d.LAN.L <- d.LAN %>% gather("year", "LAN", 4:18)
d.MOR.L <- d.MOR %>% gather("year", "MOR", 4:18)











### ----------
### 5) Dropping variables
# - In each data frame, we have unused column, "indicator"
# - We have to drop "indicator" column

## With Base R Approach
dd1 <- d.POP.L[, -which(colnames(d.POP.L)=="indicator")]
dd2 <- d.POP.L[, -3]

## With "dplyr"
dd3 <- select(d.POP.L, -indicator)
dd4 <- d.POP.L %>%
  select(-indicator)

rm(dd1, dd2, dd3, dd4)

### Practice 3: Dropping variables
## Storing data sets without "indicator" column
d.POP.L <- d.POP.L %>% select(-indicator) ## Overwrite object. 
d.GDP.L <- d.GDP.L %>% select(-indicator) ## Newly defined object will replace old one.
d.POP.L <- d.POP.L %>% select(-indicator)
d.HEX.L <- d.HEX.L %>% select(-indicator)
d.LAN.L <- d.LAN.L %>% select(-indicator)
d.MOR.L <- d.MOR.L %>% select(-indicator)









### ----------
### 6) Merging data
# - We have POP, HEX, LAN, MOR data, but want to merge them as a single data frame
# - They should be merged based on country name, region and year

## Merge d.POP.L and d.HEX.L first
d <- full_join(d.POP.L, d.GDP.L, by=c("name", "region", "year"))

## Merge d and others by making chain
d <- full_join(d, d.HEX.L, by=c("name", "region", "year"))
d <- full_join(d, d.LAN.L, by=c("name", "region", "year"))
d <- full_join(d, d.MOR.L, by=c("name", "region", "year"))

# - Note: Merge function - left_join, right_join, inner_join, full_join













### ----------
### 7) Setting Variable Type
# - variable type in R: atomic, numeric, character, factor, integer, Date, ...
# - If you are going to use cateogorical variables (e.g., country, region), it would be better to change them to factor variable
# - This makes R to consider them cateogorical variables

## To see structure of data frame or see each variable's data type

## With Base R Approach
str(d)

## With "dplyr" package
glimpse(d)

## Converting to character vairable
d$name <- as.character(d$name) # Dollar sign means "column"

## Converting to factor variable
d$name <- as.factor(d$name)
d$region <- as.factor(d$region)

## Converting to numeric variable
d$GDP <- as.numeric(d$GDP)

### Practice 4: Setting Variable Type
# - We want to set up "year" as a numeric variable

## Erase "y"
d$year <- gsub("y", "", d$year)

## Convert the type to "numeric"
d$year <- as.numeric(d$year)












### ----------
### 8) Subsetting by row - filter: Subsetting rows matching criteria

## With Base R approach
dd1 <- d[d$year==2005 & d$region=="Europe & Central Asia",]

## With "dplyr" package

dd2 <- filter(d, year==2005 & region=="Europe & Central Asia")
## AND: "&" or "," to represent AND condition
## Make table of observations in 1970 AND in region 6 from "d"

dd3 <- filter(d, year==2005 | year==2010 & region=="Europe & Central Asia")
## OR: "|" to represent | condition
## Make table of observations in 1970 OR 1980 and in region 1 from "d"

### Practice 5: Subsetting by row

## Defining as an object
dd4 <- filter(d, year==2005 & region=="North America")
dd5 <- filter(d, year==2005 & region=="North America" | region=="Latin America & Caribbean")

rm(dd1, dd2, dd3, dd4, dd5)




### ----------
### 9) Subsetting by column - select: Pick columns by name

## With Base R approach
dd1 <- d[, c("name", "year", "GDP", "HEX")]

## With "dplyr" package
dd2 <- select(d, name, year, GDP, HEX)
dd2 <- d %>% select(name, year, GDP, HEX)
## Make table whose columns are name, year, GDP, HEX from d

rm(dd1, dd2)
















### ----------
### 10) Subsetting by column and row - %>%: "Chaining" and "Piping"

## With Base R approach
dd1 <- d[which(d$region=="North America"&d$year<2010), c("name", "region", "year", "POP", "GDP")]

## With "dplyr" package
dd2 <- d %>%
  select(name, region, year, POP, GDP) %>%
  filter(year<2010)
## Among the observations before 2010,
## make table of name, year and POP and GDP

rm(dd1, dd2)


### Practice 6: Subsetting by column and row

## From observations whose POP is above 1M
## and after 2005 in "Europe & Central Asia"
## make table of GDP and POP

dd3 <- d %>%
  select(name, year, GDP, POP) %>%
  filter(POP>10000000 & year>2005)

rm(dd3)










### ----------
### 11) Reordering rows - arrange

## With Base R Approach
dd1 <- d[order(d$GDP), c("name", "year", "GDP")]

## With "dplyr"
dd2 <- d %>%
  select(name, year, GDP) %>%
  arrange(GDP)
## Among the table of name, year and GDP,
## arrange the tables from the lowest to the highest value of GDP
## with ascending order

rm(dd1, dd2)

### Practice 7: Reordering rows

## Reordering rows by country name, year and GDP
dd3 <- d %>%
  select(name, year, GDP) %>%
  arrange(name, year, GDP)

## Note: use 'desc' for descending order
dd4 <- d %>%
  select(name, year, GDP) %>%
  arrange(desc(GDP))
## Among the table of name, year and GDP,
## arrange the tables from the lowest to the highest value of "GDP"
## with descending order







### ----------
### 12) Adding new variable - mutate

## With Base R Approach
d$GDP_cap <- d$GDP/d$POP ## GDP_cap: GDP per capita
d$HEX_total <- d$HEX*d$GDP ## HEX_total: Total health expenditure

## With "dplyr"
d <- d %>%
  mutate(GDP_cap=GDP/POP, HEX_total=HEX*GDP)

## Log variables
d <- d %>%
  select(name:year, GDP, POP, HEX) %>%
  mutate(lnGDP=log(GDP))

## Other example to store
d4 <- d %>%
  select(name:year, GDP, POP, HEX, LAN) %>%
  mutate(GDP_cap=GDP/POP,
         HEX_total=HEX*GDP,
         lnGDP=log(GDP),
         DEN=POP/LAN)













### ----------
### 13) Renaming Variables

## With Base R Approach
names(d)[which(names(d)=="POP")] <- "population"
names(d)[which(names(d)=="population")] <- "POP"

## With "dplyr"
d <- d %>%
  rename(population=POP, area=LAN, health=HEX)
## rename POP -> "population", LAN -> "area", HEX -> "health"













### ----------
### 14) Summarising data table

## With Base R Approach
t1 <- aggregate(POP ~ region + year, d, sum)
## Make table of sum of population by year

## With "dplyr"
t2 <- d %>%
  group_by(region, year) %>% ## observations will be grouped by year
  summarise(POP_sum=sum(POP, na.rm=T))
## Make table of sum of population by year

t <- d %>%
  group_by(region, year) %>% ## observations will be grouped by region and year
  summarise(POP=sum(POP, na.rm=T),
            GDP=sum(GDP, na.rm=T),
            HEX_total=sum(HEX*GDP, na.rm=T),
            GDP_cap=sum(GDP, na.rm=T)/sum(POP, na.rm=T),
            DEN=sum(POP, na.rm=T)/sum(LAN, na.rm=T))










### ----------
### 15) Saving Data as .RData
```{r}
## Saving the whole objects in the environment
save.image("data.RData")

## Saving selected objects
save(d, t, file="table.RData")

## Exporting as CSV file
write.csv(d, "data.csv", row.names=F)










### ----------
## 3. Some Useful functions for Data Exploration

### ----------
### Random sampling

s1 <- sample_n(d, size=100, replace=T)
s2 <- sample_n(d %>%
           filter(year==2010), size=40, replace=F)











### ----------
### Frequency Table

t2 <- d %>%
  filter(year==2012) %>%
  count(region) %>%
  mutate(prop=prop.table(n))

t3 <- d %>%
  count(region, year) %>%
  mutate(prop=prop.table(n))



### ----------
### Formatting table in APA format
# - Use "apaStyle" package
# - Use ["stargazer"](http://jakeruss.com/cheatsheets/stargazer.html) packagefor formatting table neatly

install.packages("apaStyle")
library("apaStyle")

# APA table
apa.table(data=t2,
          level1.header=c("Region", "Number", "Percentage"),
          title="Frequency table",
          note="Year is 2012.",
          file="APA_table.docx")

# - Note) Other functions for descriptive statistics and regression table
# - apa.descriptives, apa.regression 
# (See (https://cran.r-project.org/web/packages/apaStyle/apaStyle.pdf)
