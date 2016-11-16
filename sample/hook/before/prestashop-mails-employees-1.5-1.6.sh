#/bin/bash
# configuration
dst_mail_send="email@domain.com"

# update employees mails
MSG=" + Update employees mails 1.6 (DB:ps_employee.email)";
if [ -n "$dst_mail_send" ]; then
    echo -n "$MSG"
    mail_locale=${dst_mail_send%@*}
    mail_domain=${dst_mail_send#*@}
    #MAJ la config des noms de domaine dans la BD
    echo "UPDATE ps_contact SET email = CONCAT('$mail_locale+', LEFT(email, LOCATE('@', email, 1)), '$mail_domain'); " >> $sqlfile;
    echo "UPDATE ps_employee SET email = CONCAT('$mail_locale+', LEFT(email, LOCATE('@', email, 1)), '$mail_domain'); " >> $sqlfile;
    #affichage OK
    let COL=70-${#MSG}
    printf "%${COL}s\n" "OK"
else
    echo -n "$MSG"
    let COL=70-${#MSG}
    printf "%${COL}s\n" "--"
fi
