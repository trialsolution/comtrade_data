#
#  Import COMTRADE data query from raw .csv
#

library('dplyr')

bigdata <- read.csv(file="inst//extdata//DataMIntraComm-Export_mihaly.csv", quote="\"", sep=",", header=TRUE)
bigdata <- tbl_df(bigdata)

save(bigdata, file="data/bigdata.rdata")


#
#  Note that the original CSV contained non-numeric codes for HS
#  Those non-numeric codes are removed in the file ending to ...MODIFIED.csv
#
commodities <- read.csv(file="inst//extdata//COMTRADE HS2007 - COMMODITIES MODIFIED.csv", colClasses=c("character","factor","character"))
commodities <- tbl_df(commodities)
colnames(commodities) <- c("Commodity", "hs_code", "Commodity2")


#  note that Namibia's iso2 code (NA) would be missing value in R by default => use the na.strings option
partners <- read.csv(file="inst//extdata//COMTRADE HS2007 - PARTNERS.csv", na.strings=" ")
partners <- tbl_df(partners)
partners <- filter(partners, Name!="Common items")
colnames(partners)[[1]] <- "Partner"


#
#  Change


reporters <- read.csv(file="inst//extdata//COMTRADE HS2007 - REPORTERS.csv", na.strings=" ")
reporters <- tbl_df(reporters)
reporters <- filter(reporters, Name!="Common items")
colnames(reporters)[[1]] <- "Reporter"


#
# check for missing hs codes
#
check <- bigdata %>% left_join(commodities)
empty_hs6 <- check %>% filter(is.na(hs_code))
write.csv(empty_hs6, file="empty_hscode.csv", row.names=FALSE)


#
# find duplicate hs codes
#
duplicates  <- check %>% group_by(Commodity, Year, Fact, Partner, Reporter, Trade.flow)  %>% summarize(number=n()) %>% filter(number>1)



#
# check for missing partner code
#
check_partners <- bigdata %>% left_join(partners)
empty_partners <- check_partners %>% filter(is.na(CTY.Code))


#
# check for missing reporters
#
check_reporters <- bigdata %>% left_join(reporters)
empty_reporters <- check_reporters %>% filter(is.na(CTY.Code))





#
# saving concordance tables
#
save(partners, file="data/partners.rdata")
save(reporters, file="data/reporters.rdata")
save(commodities, file="data/commodities.rdata")



#
# cleanin up
#
rm(empty_reporters, empty_partners, empty_hs6)
rm(check_reporters, check_partners, check)
rm(bigdata)



