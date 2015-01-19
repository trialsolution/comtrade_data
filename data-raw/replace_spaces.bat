@echo on
rem the -F flag specifies the separator
rem the $7 stands for the seventh column
 
awk < beefdata.csv -F, '{ gsub(" ","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > beeftemp.csv
awk < beeftemp.csv -F, '{ gsub(":","",$7); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > beeftemp1.csv
awk < beeftemp1.csv -F, '{ gsub("52","",$1); print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' > beeftemp2.csv



