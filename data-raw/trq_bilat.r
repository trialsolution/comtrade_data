#
#  read in policy data (compiled originally from legislative texts in an Excel sheet)
#
trq_bilat <- read.csv(file="inst//extdata//trq_bilat.csv", header=TRUE, stringsAsFactors=TRUE)
trq_bilat <- tbl_df(trq_bilat)

#  replace 'eps' with zero
levels(trq_bilat$TaPref) <- c(levels(trq_bilat$TaPref), "0")
trq_bilat$TaPref[trq_bilat$TaPref == "eps"] <- 0
trq_bilat$TaPref <- as.numeric(as.character(trq_bilat$TaPref))

levels(trq_bilat$TsPref) <- c(levels(trq_bilat$TsPref), "0")
trq_bilat$TsPref[trq_bilat$TsPref == "eps"] <- 0
trq_bilat$TsPref <- as.numeric(as.character(trq_bilat$TsPref))

save(trq_bilat, file='data/trq_bilat.rdata')