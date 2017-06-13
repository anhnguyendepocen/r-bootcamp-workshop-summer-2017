# R Bootcamp for UNCC Faculty

## Sponsored by 
* [Project Mosaic](https://projectmosaic.uncc.edu/)

## Date, Time and Location

* June 15-16, 2017

* 9:30am - 12:30pm

* Kennedy 236
 
## Instructors

* [Kailas Venkitasubramanian](https://projectmosaic.uncc.edu/people/kailas-venkitasubramanian/)

* [Paul Jung](https://projectmosaic.uncc.edu/people/paul-jung/)

* [Ryan Wesslen](http://wesslen.github.io)

## Set up

For this workshop, participants are expected to bring their laptops with R and R Studio already installed. 

Here are pre-workshop preparation steps:

1.  Download the workshop materials from this repository using the "Clone or download" button and click the "Download ZIP" link. Unzip the file locally (for example, Desktop or My Documents folder)

2.  Ensure you have [R](http://archive.linux.duke.edu/cran/) and [R Studio](https://www.rstudio.com/products/rstudio/download/) installed on your machine. Use the links and follow the instructions to download each locally.

3.  After installing R and R Studio, open R Studio and run the following command to ensure you have all of the R libraries we'll use:

```{r}
packages <- c("tidyverse","apaStyle","ggthemes","lme4","multilevel")
install.packages(packages, dependencies = TRUE)
```

## Day 1: June 15

| Part | Subject                               |        |           |
| ---- | ------------------------------------- | ------ | --------- |
|    1 | R Essentials & Data Management        | [code](/data-management.Rmd) | [HTML output](https://htmlpreview.github.io/?https://rawgit.com/wesslen/r-bootcamp-workshop-summer-2017/master/data-management.html)   |
|   2a | Visualizations: ggplot2 introduction  | [code](/ggplot2-introduction.Rmd) | [HTML output](https://rawgit.com/wesslen/r-bootcamp-workshop-summer-2017/master/ggplot2-introduction.html)   |

## Day 2: June 16

| Part | Subject                                |        |           |
| ---- | -------------------------------------  | ------ | --------- |
|   2b | Visualizations: Interactive plots      | [code](/interactive-plots.Rmd) | [HTML output](https://rawgit.com/wesslen/r-bootcamp-workshop-summer-2017/master/interactive-plots.html)   |
|    3 | Regression Modeling                    | [code](/regression-modeling.Rmd) | [HTML output](https://htmlpreview.github.io/?https://rawgit.com/wesslen/r-bootcamp-workshop-summer-2017/master/regression-modeling.html)   |

## Helpful Links

Here are multiple links and references we'll mention during the workshop.

### Introduction to R

*   Brooke Anderson's [R Programming for Research](https://github.com/geanders/RProgrammingForResearch)

*   [Tutorial 1](https://github.com/geanders/RProgrammingForResearch/raw/master/slides/CourseNotes_Week1.pdf)

*   [Tutorial 2](https://github.com/geanders/RProgrammingForResearch/raw/master/slides/CourseNotes_Week2.pdf)

### Links for Tools

*   [RMarkdown](http://rmarkdown.rstudio.com/)

*   [HTMLWidgets](http://www.htmlwidgets.org/)

*   [Flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/)

*   [Shiny](https://shiny.rstudio.com/)

### Links for Publishing R Files

*   [RPubs](https://rpubs.com/)

*   [Shinyapps.io](https://www.shinyapps.io/)

### Great R References

*   [Winston Chang's Cookbook for R](http://www.cookbook-r.com/)

*   [Dean Attali's Shiny Demos](http://deanattali.com/shiny/)

*   [Dean Attali's Shiny Tutorial](http://deanattali.com/blog/building-shiny-apps-tutorial/)
