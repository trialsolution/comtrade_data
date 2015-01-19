library("dplyr")
library("RSQLite")
library("gdxrrw")
igdx("n://soft//gams")
library("stringr")
library("ggplot2")

#
#  load 2014 (latest) Aglink baseline from an SQLite database
#  The SQLite database is created from the gdx file in the /dat/baseline folder
#
sqlite <- dbDriver("SQLite")
db <- dbConnect(sqlite,"inst//extdata//aglink.db")
p_res <- dbGetQuery(db, "select * from p_res")
pres <- tbl_df(p_res)

#  remove the 'A' at the and of the years (make them numeric values)
pres$p_res5 <- substr(pres$p_res5,1,4)



#
# find ad valorem tariff-related data
#
pres %>% filter(p_res4=="BV", p_res=="EUN", grepl("TAV",p_res3))
pres %>% filter(p_res4=="BV", p_res=="EUN", grepl("TRQ",p_res3))
tocheck <- pres %>% 
  filter(p_res2=="Value") %>% 
  filter(p_res4=="BV", p_res=="EUN", grepl("IMM",p_res3))


#
#  load 2013 Aglink baseline directly from the gdx
#
info <- gdxInfo("inst//extdata//aglink2013dgAgri_oriData.gdx", dump=FALSE, returnDF=TRUE)
mytemp <- rgdx.param("inst//extdata//aglink2013dgAgri_oriData.gdx", "p_aglinkOri")
aglink13 <- tbl_df(mytemp)
aglink13 %>% filter(i1 == "EUN", i3=="BV", grepl("TRQ",i2))  
aglink13 %>% filter(i1 == "EUN", i3=="BV", grepl("IMM",i2))  

