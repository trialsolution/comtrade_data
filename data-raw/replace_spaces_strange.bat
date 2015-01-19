@echo on
rem the -F flag specifies the separator
rem the $7 stands for the seventh column
 
awk < strange.csv -F, '{ gsub(" ","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > strangetemp.csv
awk < strangetemp.csv -F, '{ gsub(":","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > strangetemp1.csv
awk < strangetemp1.csv -F, '{ gsub("52","",$1); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > strangetemp2.csv


del strangetemp.csv
del strangetemp1.csv

