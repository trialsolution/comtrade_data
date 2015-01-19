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
wgdx.lst("test_sets.gdx", tlines)

