#/bin/bash

# VARIABLES
# ssh
server=""
dist_unixuser=""

# distant
# prod
dist_dbname=""
dist_dbuser=""
dist_hostname=""
dist_root_url=""
dist_root_fs=""
sql_options="--default-character-set=utf8"
sql_ignores=""

# local
local_dbname=""
local_dbuser=""
local_root_url=""
local_root_fs=""

# TRAITEMENTS
# echappement des variables : caracteres '.' et '/'
curdate=`date +%Y%m%d%H%M%S`
local_hostname=`echo "$local_root_url"         | sed 's/\/.*//g'`
dist_root_url_escaped=`echo "$dist_root_url"   | sed 's/\//\\\\\//g'`
dist_hostname_escaped=`echo "$dist_hostname"   | sed 's/\//\\\\\//g'`
local_root_url_escaped=`echo "$local_root_url" | sed 's/\//\\\\\//g'`
local_hostname_escaped=`echo "$local_hostname" | sed 's/\//\\\\\//g'`
dist_root_fs_escaped=`echo "$dist_root_fs"     | sed 's/\//\\\\\//g'`
local_root_fs_escaped=`echo "$local_root_fs"   | sed 's/\//\\\\\//g'`
sqlfile="$(dirname $0)/$dist_dbname$curdate.sql"
logfile="$(dirname $0)/majbdlocale.log"
resilient_replace="$(dirname $0)/resilient_replace"

# dump de la base distante à travers SSH
MSG="1/5 : dump de la base distante (tunnel SSH)";
echo -n "$MSG"
echo "DROP DATABASE IF EXISTS $local_dbname; CREATE DATABASE $local_dbname; USE $local_dbname; " > $sqlfile && \
    ssh $dist_unixuser@$server "(/usr/bin/mysqldump --opt -R --no-data $sql_options -u $dist_dbuser $dist_dbname && /usr/bin/mysqldump --opt -R $sql_options $sql_ignores -u $dist_dbuser $dist_dbname) | gzip" | gunzip \
        >> $sqlfile
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"

# remplacement des URL et chemins (même sérialisés)
MSG="2/5 : remplacement des URL et chemins (même sérialisés)";
echo -n "$MSG"
$resilient_replace -i "$dist_root_url_escaped" "$local_root_url" $sqlfile
$resilient_replace -i "$dist_root_fs_escaped" "$local_root_fs" $sqlfile
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"

# adaptation spécifiques
MSG="3/5 : adaptations spécifiques";
echo -n "$MSG"
# sed -i "s/'PS_SHOP_DOMAIN','[^\']*\?'/'PS_SHOP_DOMAIN','$local_hostname'/g" $sqlfile && \
#     sed -i "s/'PS_SHOP_DOMAIN_SSL','[^\']*\?'/'PS_SHOP_DOMAIN_SSL','$local_hostname'/g" $sqlfile && \
#     rm -rf tools/smarty/compile/* && \
#     rm -rf cache/cachefs/*
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"

# importe la BD modifiee
MSG="4/5 : import de la base de données"
echo -n "$MSG"
cat $sqlfile | \
    mysql -u $local_dbuser $local_dbname --show-warnings > $logfile && \
    rm -f $sqlfile && \
    let COL=70-${#MSG} && \
    printf "%${COL}s\n" "OK"
# synchro des dossiers media
MSG="5/5 : synchro des dossiers"
echo -n "$MSG"
# rsync -vrpz --exclude=".svn/*" $dist_unixuser@$server:$dist_root_fs/files/ $local_root_fs/files/ >> $logfile && \
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
