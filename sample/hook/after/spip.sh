#/bin/bash
MSG=" + SPIP (config BD, cleanup tmp)";
echo -n "$MSG"
# MAJ la config des noms de domaine dans le .htaccess et vide les caches
sed -i "s/^ *spip_connect_db *(.*/spip_connect_db('${dst_dbhostname}','','${dst_dbuser}','${dst_dbpass}','${dst_dbname}');/g" "${dst_files_root}/config/connect.php"
sed -i "/^ *ini_set *(.display_errors.*/d" "${dst_files_root}/config/connect.php"
sed -i "s/?>/ini_set('display_errors','off');\n?>/g" "${dst_files_root}/config/connect.php"
rm -rf ${dst_files_root}/tmp
rm -rf ${dst_files_root}/local/cache-gd2
rm -rf ${dst_files_root}/local/cache-vignettes
rm -rf ${dst_files_root}/local/temp
mkdir -p ${dst_files_root}/tmp
mkdir -p ${dst_files_root}/local/cache-gd2
mkdir -p ${dst_files_root}/local/cache-vignettes
mkdir -p ${dst_files_root}/local/temp
# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
