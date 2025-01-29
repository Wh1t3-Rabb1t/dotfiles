# AWK

## Select columns from file ----------------------------------------------------
awk 'BEGIN{FS=OFS=","} {print $1,$2}' <filename>

## Check if records have same columns ------------------------------------------
awk -F ',' '{print NF}' <filename>  | sort | uniq -c | wc -l

## Change delimiter ------------------------------------------------------------
awk '$1=$1' FS="<old>" OFS="<new>" <filename>

## Search regex in column ------------------------------------------------------
awk -F ',' '$<colNr> ~/<regex>/' <filename> | column -t -s, | bat --file-name <filename>

## Exclude regex in column -----------------------------------------------------
awk -F ',' '$<colNr> !~/<regex>/' <filename> | column -t -s, | bat --file-name <filename>

## Remove all white spaces -----------------------------------------------------
awk 'BEGIN{FS=OFS=","} {gsub(/[ \t]+/,""); print }' <filename>

## Trim leading and trailing white spaces --------------------------------------
awk 'BEGIN{FS=OFS=","} { gsub(/^[ \t]+|[ \t]+$/, ""); print }' <filename>

## Replace everywhere ----------------------------------------------------------
awk 'BEGIN{FS=OFS=","} {gsub(/<pattern>/,"<replacement>"); print }' <filename>

## Replace in column -----------------------------------------------------------
awk 'BEGIN{FS=OFS=","} {gsub(/<pattern>/,"<replacement>",$<column>); print }' <filename>

## Replace in column on condition ----------------------------------------------
awk 'BEGIN{FS=OFS=","} {if(<condition>) gsub(/<pattern>/,"<replacement>",$<column>); print }' <filename>

## Data validation/condition ---------------------------------------------------
awk -F ',' '<condition> { print }' <filename>

## Remove empty lines ----------------------------------------------------------
awk NF <filename>

## Remove duplicates -----------------------------------------------------------
awk -F ',' '!seen[$0]++' <filename>

## Remove duplicates in column -------------------------------------------------
awk -F ',' '!seen[$<colNr>]++' <filename>

## Print index of empty lines --------------------------------------------------
awk '!NF {print NR}' <filename>

## Select null in column -------------------------------------------------------
awk -F ',' '$<colNr> ~/^$/' <filename>

## Exclude null in column ------------------------------------------------------
awk -F ',' '$<colNr> !~/^$/' <filename>

## Search for only spaces in column --------------------------------------------
awk -F ',' '$<colNr> ~/^[[:blank:]]+$/' <filename>

## Select row by index ---------------------------------------------------------
awk -F ',' 'NR==<index>' <filename>

## Count lines that match pattern ----------------------------------------------
awk -F ',' '/<pattern>/{++count} END {print count}' <filename>

## Count distinct --------------------------------------------------------------
: <filename>; awk -F ',' 'NR > 1 {print $<colNr>}' <filename> | sort | uniq -c | wc -l

## Count frequencies of values in column ---------------------------------------
: <filename>; awk -F ',' 'NR!=1 {print $<colNr>}' <filename> | sort | uniq -c | sort -nr

$ filename: fd -I -t f -e csv
$ colNr: xsv headers <filename> --- --column 1
