#/bin/bash
MSG=" + Drupal 7 (empty caches)";
echo -n "$MSG"

# empty drupal caches
SQL_EMPTY_CACHES="$(grep '^CREATE TABLE `\(cache\|cache_\|[^ ]*_cache_\|[^ ]*_cache\)' $sqlfile | sed 's/CREATE TABLE /TRUNCATE /g' | sed 's/ (/;/g')"
echo "$SQL_EMPTY_CACHES" >> $sqlfile;

# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
