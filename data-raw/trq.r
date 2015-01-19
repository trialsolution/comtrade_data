#
#  Policy data
#
trq <- read.csv(file="inst//extdata//beef_trq.csv", header=TRUE)
trq <- tbl_df(trq)

#  replace 'eps' with zero
levels(trq$TaPref) <- c(levels(trq$TaPref), "0")
trq$TaPref[trq$TaPref == "eps"] <- 0
trq$TaPref <- as.numeric(as.character(trq$TaPref))
trq$TaPref <- trq$TaPref * 100

save(trq, file='data/trq.rdata')
