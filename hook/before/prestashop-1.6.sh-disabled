#/bin/bash
MSG=" + Prestashop 1.6 (DB:ps_shop_url.physical_uri)";
echo -n "$MSG"
# MAJ la config des noms de domaine dans la BD
echo "UPDATE ps_shop_url SET physical_uri = '$dst_root_slug/'; " >> $sqlfile;
# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
