#
# Example for using the generic wgdx() function 
#

library("dplyr")
library("gdxrrw")
library("ggplot2")

#
# Multidimensional sample dataset: Nr. of cylinders in car engines
#
cylinders <- select(mpg, manufacturer, model, displ, year, cyl)


#
# Only factors can be exported to dimensions of GAMS parameters
#
cylinders$displ <- factor(cylinders$displ)
cylinders$year <- factor(cylinders$year)



#
# Create the UEL list (unique elements in the dimensions)
# They must be unnamed lists which complicates life (and increses code length)
#
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


#
# Create the data.frame that will be written out:
#     The factors must be converted to unique integer values (see as.numeric(factors))
#
myval <- data.frame(manu=as.numeric(cylinders$manufacturer), 
                    model=as.numeric(cylinders$model), disp=as.numeric(cylinders$displ), 
                    year=as.numeric(cylinders$year), val=cylinders$cyl)

#
# Create the list that will be fed directly to wgdx()
#
cyl_list <- list(name="cylinder", type="parameter", dim=4, form="sparse", ts="cylinder values", val=as.matrix(myval), 
                 uels=c(uel_1, uel_2, uel_3, uel_4))


wgdx("cyl2.gdx", cyl_list)

