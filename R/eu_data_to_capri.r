#
#  Create an input data file for further use in CAPRI
#  Merge and then remove unnecessary columns
#


#  load data and dictionaries to memory

library('dplyr')

load(file="data/eu15.rdata")
load(file="data/eu27.rdata")
load(file="data/partners.rdata")
load(file="data/reporters.rdata")
load(file="data/commodities.rdata")

bigdata <- rbind(eu27, eu15)
rm(eu15,eu27)

myselection <- select(bigdata, Year, Reporter, Partner, Trade.flow, Commodity, UOM, Value.in.UN...COMTRADE...Agricultural.and.fish.products.HS2007)
colnames(myselection) <- c('year','reporter','partner','tradeflow','commodity','uom','value')

# defining factors
myselection$year <- factor(myselection$year)
#myselection$commodity <- factor(myselection$commodity)



#
#  Creating input data table
#

#  Resolve tariff line (hs6) codes
comtrade_capri <- myselection %>% left_join(commodities, by=c('commodity' = 'Commodity')) 

#  Reorder + bring reporter to first position, as was the case with the previous comtrade data extraction (non-EU15 reporters)
comtrade_capri  <- comtrade_capri %>% select(hs_code, commodity, partner, reporter, tradeflow, year, uom, value)

#  Resolve partner regional codes
comtrade_capri <- comtrade_capri %>% left_join(partners, by=c('partner' = 'Partner'))
comtrade_capri  <- comtrade_capri %>% select(hs_code, commodity, partner, CTY.Code, reporter, tradeflow, year, uom, value)
colnames(comtrade_capri) <- c("hs_code", "commodity","partner", "partnercode", "reporter", "tradeflow", "year", "uom", "value")

#  Resolve reporter regional codes
comtrade_capri  <- comtrade_capri %>% left_join(reporters, by=c("reporter" = "Reporter"))
comtrade_capri  <- comtrade_capri %>% select(hs_code, commodity, partner, partnercode, reporter, CTY.Code, tradeflow, year, uom, value)
colnames(comtrade_capri) <- c("hscode", "commodity", "partner", "partnercode", "reporter", "reportercode", "tradeflow", "year", "uom", "value")



comtrade_capri <- comtrade_capri %>%
  select(tradeflow, hscode, reporter, reportercode, partner, partnercode, year, uom, value)

comtrade_capri <- comtrade_capri %>%
  select(tradeflow, hscode, reportercode, partnercode, year, uom, value)

#  removing hs codes that could not be mapped in the dictionary file
comtrade_capri <- comtrade_capri %>%
  filter(!is.na(hscode))

comtrade_capri$reportercode <- factor(comtrade_capri$reportercode)
comtrade_capri$partnercode  <- factor(comtrade_capri$partnercode)
comtrade_capri$year         <- factor(comtrade_capri$year)

eu_capri <- comtrade_capri
rm(comtrade_capri, myselection)

save(eu_capri, file="data/eu_capri.rdata")

#
#  Write info to a .gdx so that CAPRI can pick it up
#
library('gdxrrw')


#
#  Note that there might be problems to write tbl_df objects to .gdx
#  => better to convert them back to normal data.frames
eu_capri <- data.frame(eu_capri)


#
# Add attributes (symbol name and  .ts)
#
attr(eu_capri, "symName") <- "comtrade_hs"
attr(eu_capri, "ts")      <- "comtrade bilateral data at tariff line level"

wgdx.lst('gdx//comtrade_hs_eu.gdx', eu_capri)


##################################################################################


