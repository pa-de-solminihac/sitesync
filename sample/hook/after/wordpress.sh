#/bin/bash
MSG=" + Wordpress (.htaccess)";
echo -n "$MSG"
# MAJ la config des noms de domaine dans le .htaccess et vide les caches
$dst_path_to_php $dst_path_to_resilient_replace -i "RewriteCond %{HTTP_HOST} \\^${src_site_host}\\$" "RewriteCond %{HTTP_HOST} ^${dst_site_host}$" "${dst_files_root}/.htaccess"
$dst_path_to_php $dst_path_to_resilient_replace -i "RewriteCond %{HTTP_HOST} \\^www.${src_site_host}\\$" "RewriteCond %{HTTP_HOST} ^${dst_site_host}$" "${dst_files_root}/.htaccess"
$dst_path_to_php $dst_path_to_resilient_replace -i "\[E=REWRITEBASE:\/\]" "[E=REWRITEBASE:${dst_root_slug}/]" "${dst_files_root}/.htaccess"
$dst_path_to_php $dst_path_to_resilient_replace -i "ErrorDocument 404 \/index\.php" "ErrorDocument 404 ${dst_root_slug}/index.php" "${dst_files_root}/.htaccess"
# problemes de droits ?
# chmod -R 777 ${dst_files_root}/cache/smarty/compile
# chmod -R 777 ${dst_files_root}/cache/cachefs
# chmod -R o+rx ${dst_files_root}
# affichage OK
let COL=70-${#MSG}
printf "%${COL}s\n" "OK"
