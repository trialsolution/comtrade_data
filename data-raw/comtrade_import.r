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
commodities <- read.csv(file="inst//extdata//COMTRADE HS2007 - COMMODITIES MODIFIED.csv")
commodities <- tbl_df(commodities)

partners <- read.csv(file="inst//extdata//COMTRADE HS2007 - PARTNERS.csv")
partners <- tbl_df(partners)

reporters <- read.csv(file="inst//extdata//COMTRADE HS2007 - REPORTERS.csv")
reporters <- tbl_df(reporters)


#
# check for missing hs codes
#
colnames(commodities) <- c("Commodity", "hs_code", "Commodity2")
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
colnames(partners)[[1]] <- "Partner"
check_partners <- bigdata %>% left_join(partners)
empty_partners <- check_partners %>% filter(is.na(CTY.Code))


#
# check for missing reporters
#
colnames(reporters)[[1]] <- "Reporter"
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



