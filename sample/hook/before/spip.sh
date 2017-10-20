#/bin/bash
MSG=" + SPIP (fix latin1)";
echo -n "$MSG"
sed -i 's/^\/\*!40101 SET NAMES latin1 \*\/;/\/\*!40101 SET NAMES utf8 \*\/;/g' $sqlfile
# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
