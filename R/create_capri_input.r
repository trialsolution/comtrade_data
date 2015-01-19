#
#  Create an input data file for further use in CAPRI
#  Merge and then remove unnecessary columns
#


#  load data and dictionaries to memory

library('dplyr')

load(file="data/bigdata.rdata")
load(file="data/partners.rdata")
load(file="data/reporters.rdata")
load(file="data/commodities.rdata")


#
#  Creating input data table
#

comtrade_capri <- bigdata %>% left_join(commodities) %>%
  left_join(partners) 

comtrade_capri <- comtrade_capri %>% select(Trade.flow, hs_code, Partner, CTY.Code, Reporter, Year, UOM, Value.in.UN...COMTRADE...Agricultural.and.fish.products.HS2007)
colnames(comtrade_capri) <- c("tradeflow", "hscode", "partner", "partnercode", "Reporter", "year", "uom", "value")

comtrade_capri <- comtrade_capri %>% left_join(reporters)
colnames(comtrade_capri) <- c("reporter", "tradeflow", "hscode", "partner", "partnercode", "year", "uom", "value", "reportercode", "iso3", "iso2")

comtrade_capri <- comtrade_capri %>%
  select(tradeflow, hscode, reporter, reportercode, partner, partnercode, year, uom, value)

comtrade_capri <- comtrade_capri %>%
  select(tradeflow, hscode, reportercode, partnercode, year, uom, value)

#  removing hs codes that could not be mapped in the dictionary file
comtrade_capri <- comtrade_capri %>%
  filter(!is.na(hscode))

comtrade_capri$reportercode <- factor(comtrade_capri$reportercode)
comtrade_capri$partnercode <- factor(comtrade_capri$partnercode)
comtrade_capri$year <- factor(comtrade_capri$year)


#
#  Write info to a .gdx so that CAPRI can pick it up
#
library('gdxrrw')


#
#  Note that there might be problems to write tbl_df objects to .gdx
#  => better to convert them back to normal data.frames
comtrade_capri <- data.frame(comtrade_capri)


#
# Add attributes (symbol name and  .ts)
#
attr(comtrade_capri, "symName") <- "comtrade_hs"
attr(comtrade_capri, "ts")      <- "comtrade bilateral data at tariff line level"

wgdx.lst('comtrade_hs.gdx', comtrade_capri)


##################################################################################




