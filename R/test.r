library(gdxrrw);

#1 use dataframe mtcars and make it useful as a parameter in GAMS
head(mtcars);

#2 we have the name of the car as row.names but not as a column in the dataframe
#  so we add the car name as a factor to the dataframe
GAMSparameter=mtcars;
GAMSparameter$CarName=factor(row.names(GAMSparameter));

#3 parameters in GAMS are a dataframe with all factor columns and 1 value column
#  we can get this easy by using the melt function
GAMSparameter=melt(GAMSparameter,id=c('CarName'),variable.name='CollectedData');
#N.B. id=c('CarName') is just a list of all sets used in the parameter that
#are aready in the dataframe. variable.name='CollectedData' just gives the name of the
#set that cointains all the variables...

#4 Add the metainformation to the dataframe
attr(GAMSparameter,"symName")="mtcars";
attr(GAMSparameter,"ts")="Example of mtcars in GDX";

#5 save the dataframe
wgdx.lst('demo.gdx',GAMSparameter);


#
# Example with the Orange dataset (in base R)
#

library("dplyr")
library("gdxrrw")
library("ggplot2")

cylinders <- select(mpg, manufacturer, model, displ, year, cyl)
cylinders$displ <- factor(cylinders$displ)
cylinders$year <- factor(cylinders$year)

attr(cylinders, "symName") <- "cylinders"
wgdx.lst('cylinders.gdx', cylinders)



create_uel <- function(myvar){
  x <- levels(myvar)[[1]]
  
  for(i in 2:length(levels(myvar))){
    x <- c(x, levels(myvar)[[i]])
  }
  return(list(x))
}


uel_1 <- create_uel(cylinders$manufacturer)
uel_2 <- create_uel(cylinders$model)
uel_3 <- create_uel(cylinders$displ)
uel_4 <- create_uel(cylinders$year)


myval <- array(cylinders$cyl, dim=c(length(unique(cylinders$manufacturer)), length(unique(cylinders$model)),  length(unique(cylinders$displ)), length(unique(cylinders$year))))

# id=row.names(cylinders), 
myval <- data.frame(manu=as.numeric(cylinders$manufacturer), 
                    model=as.numeric(cylinders$model), disp=as.numeric(cylinders$displ), year=as.numeric(cylinders$year), val=cylinders$cyl)

cyl_list <- list(name="cylinder", type="parameter", dim=4, form="sparse", ts="cylinder_values", val=as.matrix(myval), 
                      uels=c(uel_1, uel_2, uel_3, uel_4))

wgdx("cyl2.gdx", cyl_list)


