#
#  read in EUROSTAT data
#
x <- read.csv(file="inst//extdata//beeftemp2.csv", header=TRUE, stringsAsFactors=TRUE, na.strings="", colClasses=c(rep("character",7)))

#
#  changes in data structure
#
x$PERIOD  <- factor(x$PERIOD)
x$REPORTER <- factor(x$REPORTER)
x$PARTNER <- factor(x$PARTNER)
x$PRODUCT <- factor(x$PRODUCT)
x$Value <- as.numeric(x$Value)

#  the "flow" dimension is always "imports" == 1
x <- x[,!(names(x)) %in% c("FLOW")]

#
#  remove missing values (NA)
#
colnames(x) <- c("period","reporter","partner","product","variable","value")

#  convert data table to a 'table' format (using dplyr)
x <- tbl_df(x)

xx <- dcast(x, period + reporter + partner + product ~ variable, sum)
xx <- subset(xx, !is.na(QUANTITY_IN_100KG | !is.na(VALUE_IN_EUROS)))
mx <- melt(xx, id=c("period","reporter","partner","product"))
mx <- tbl_df(mx)

#  remove temporary data frame
rm(xx)
rm(x)

##################################
#  load in missing tariff line 021020
x <- read.csv(file="inst//extdata//tlinetemp2.csv", header=TRUE, stringsAsFactors=TRUE, na.strings="", colClasses=c(rep("character",7)))

#
#  changes in data structure
#
x$PERIOD  <- factor(x$PERIOD)
x$REPORTER <- factor(x$REPORTER)
x$PARTNER <- factor(x$PARTNER)
x$PRODUCT <- factor(x$PRODUCT)
x$Value <- as.numeric(x$Value)

#  the "flow" dimension is always "imports" == 1
x <- x[,!(names(x)) %in% c("FLOW")]

#
#  remove missing values (NA)
#
colnames(x) <- c("period","reporter","partner","product","variable","value")

#  convert data table to a 'table' format (using dplyr)
x <- tbl_df(x)

xx <- dcast(x, period + reporter + partner + product ~ variable, sum)
xx <- subset(xx, !is.na(QUANTITY_IN_100KG | !is.na(VALUE_IN_EUROS)))
mx2 <- melt(xx, id=c("period","reporter","partner","product"))
mx2 <- tbl_df(mx2)

#  remove temporary data frame
rm(xx)
rm(x)


##################################
#  find big exporters in tariff line 021020
x <- read.csv(file="inst//extdata//strangetemp2.csv", header=TRUE, stringsAsFactors=TRUE, na.strings="", colClasses=c(rep("character",7)))

#
#  changes in data structure
#
x$PERIOD  <- factor(x$PERIOD)
x$REPORTER <- factor(x$REPORTER)
x$PARTNER <- factor(x$PARTNER)
x$PRODUCT <- factor(x$PRODUCT)
x$Value <- as.numeric(x$Value)

#  the "flow" dimension is always "imports" == 1
x <- x[,!(names(x)) %in% c("FLOW")]

#
#  remove missing values (NA)
#
colnames(x) <- c("period","reporter","partner","product","variable","value")

#  convert data table to a 'table' format (using dplyr)
x <- tbl_df(x)

xx <- dcast(x, period + reporter + partner + product ~ variable, sum)
xx <- subset(xx, !is.na(QUANTITY_IN_100KG | !is.na(VALUE_IN_EUROS)))
mx3 <- melt(xx, id=c("period","reporter","partner","product"))
mx3 <- tbl_df(mx3)

#  remove temporary data frame
rm(xx)
rm(x)


#
#  Switzerland (CH) is the biggest exporter!!!
#  In posses of a TRQ with duty-free access (82/2013)
#
mx3 %>% group_by(period,partner)  %>% 
  filter(reporter=="EU28")  %>% filter(variable=="QUANTITY_IN_100KG")  %>% 
  summarise(quant=sum(value)) %>% arrange(desc(quant))  %>% filter(period=="2013")

#
#  the overall imports under this tariff line are, however, relatively small
#  Note that the quantities are in 100kg's
#
mx3 %>% group_by(period,partner)  %>% 
  filter(reporter=="EU28")  %>% filter(variable=="QUANTITY_IN_100KG")  %>% 
  summarise(quant=sum(value)/10) %>% arrange(desc(quant))  %>% filter(partner=="EU28_EXTRA")


##################################

#  Merge the two data sets
#  Put Switzerland aside
beef <- rbind(mx,mx2)
save(beef, file='data/beef.rdata')

rm(mx)
rm(mx2)
rm(mx3)
