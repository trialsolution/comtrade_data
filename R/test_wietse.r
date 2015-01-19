#
# Example for using wgdx.lst
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
# Add attributes (symbol name and  .ts)
#
attr(cylinders, "symName") <- "cylinders"
attr(cylinders, "ts")      <- "cylinders"

wgdx.lst('cylinders.gdx', cylinders)