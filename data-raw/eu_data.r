# importing COMTRADE data for the missing EU aggregates: eu15 and eu27

library("dplyr")


eu15p <- read.csv(file="inst/extdata/eu_15_prices.csv", header=TRUE)
eu15p <- tbl_df(eu15p)


eu15v <- read.csv(file="inst/extdata/eu_15_values.csv", header=TRUE)
eu15v <- tbl_df(eu15v)

# putting values and prices together
eu15 <- rbind(eu15p,eu15v)

save(eu15, file='data/eu15.rdata')

rm(list=ls())


eu27p <- read.csv(file="inst/extdata/eu27_calc_prices.csv", header=TRUE)
eu27p <- tbl_df(eu27p)


eu27v <- read.csv(file="inst/extdata/eu27_calc_values.csv", header=TRUE)
eu27v <- tbl_df(eu27v)

# putting values and prices together
eu27 <- rbind(eu27p,eu27v)

save(eu27, file='data/eu27.rdata')

rm(list=ls())
