#/bin/bash
MSG=" + fix latin1 database encoding";
echo -n "$MSG"
iconv -f latin1 -t utf8 -o $sqlfile_tmp $sqlfile && mv $sqlfile_tmp $sqlfile
sed -i 's/^\/\*!40101 SET NAMES latin1 \*\/;/\/\*!40101 SET NAMES utf8 \*\/;/g' $sqlfile
# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
