@echo on
rem the -F flag specifies the separator
rem the $7 stands for the seventh column
 
awk < tline_021020.csv -F, '{ gsub(" ","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > tlinetemp.csv
awk < tlinetemp.csv -F, '{ gsub(":","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > tlinetemp1.csv
awk < tlinetemp1.csv -F, '{ gsub("52","",$1); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > tlinetemp2.csv


del tlinetemp.csv
del tlinetemp1.csv

