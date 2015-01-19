#
#  Saving the code dictionaries as multidimensional GAMS sets
#


tlines <- read.csv(file="inst//extdata//COMTRADE HS2007 - COMMODITIES MODIFIED.csv", colClasses=c("character","factor","character"))

colnames(tlines) <- c("label", "hscode", "label2")
tlines <- tbl_df(tlines)
tlines <- select(tlines, hscode, label)
tlines <- tlines %>%
  filter(!is.na(hscode))

tlines <- as.data.frame(sapply(tlines,gsub,pattern=",",replacement=" "))
tlines <- as.data.frame(sapply(tlines,gsub,pattern=";",replacement=" "))
tlines <- as.data.frame(sapply(tlines,gsub,pattern="\\.",replacement=""))

# too long labels must be truncated (problem with wgdx)
tlines <- as.data.frame(sapply(tlines,substr, start=1, stop=30))


tlines$label <- factor(tlines$label)
tlines$hscode <- factor(tlines$hscode)

attr(tlines, "symName") <- "hs_lines"
wgdx.lst("gdx//tarifflines.gdx", tlines)


#
#  partners code list
#

load("data/partners.rdata")

colnames(partners) <- c("partner", "cty", "iso3", "iso2")

filter(partners, is.na(cty))

partners <- data.frame(partners)
partners$cty <- factor(partners$cty)


attr(partners, "symName") <- "partners"
wgdx.lst("gdx//partners.gdx", partners)


#
#  reporters code list
#

load("data/reporters.rdata")

colnames(reporters) <- c("partner", "cty", "iso3", "iso2")

filter(reporters, is.na(cty))

reporters <- data.frame(reporters)
reporters$cty <- factor(reporters$cty)


attr(reporters, "symName") <- "reporters"
wgdx.lst("gdx//reporters.gdx", reporters)

