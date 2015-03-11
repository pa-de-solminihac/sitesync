Sitesync
===

***Synchronise un site local avec un site distant.***

Installation
===

```bash
git clone https://github.com/pa-de-solminihac/sitesync
```

Configuration basique
===

L'outil a besoin d'un fichier de configuration pour fonctionner. On peut se baser sur le fichier `config-sample` fourni :
```bash
cp etc/config-sample etc/config
```

Il faut ensuite éditer le fichier `etc/config` pour l'adapter à notre besoin.

```bash
vim etc/config
```

Vous pouvez ajouter des scripts à appliquer avant / après l'import de la base de données dans les dossiers `/hook/before` et `hook/after`. À titre d'exemple, des hooks pour Prestashop 1.6 sont présents. 

__Important__ : il faut renommer les scripts hook en leur donnant l'extension `.sh` pour qu'ils soient pris en compte !

Utilisation
===

Une fois la configuration effectuées, il suffit de lancer le script sync :

```bash
./sync
```

Pour ne synchroniser que les fichiers :

```bash
./sync files
```

Pour ne synchroniser que la base de données :
```bash
./sync sql
```

***Astuce***

Pour ne pas avoir à saisir le mot de passe SSH à chaque fois, utiliser l'accès SSH par clés :

```bash
ssh-copy-id user@server
```

Si votre clé SSH est protégée par mot de passe et que vous êtes déjà au sein d'une connexion SSH, pensez à :

```bash
eval "$(ssh-agent)"
```

Configuration avancée
===

Configuration des chercher-remplacer : 
```ini
replace_src[0]="chaine à chercher numéro 0"
replace_dst[0]="chaine qui remplace la chaine numéro 0"
```

Configuration des dossiers à synchroniser :
```ini
sync_src[0]="$src_files_root/files/media"
sync_dst[0]="$dst_files_root/files/media"
```

Options de synchronisation de la base de données :
```ini
src_type="local_file|local_base|remote_file|remote_base"
```

Si __src_type__ est `local_file` ou `remote_file`, il faut préciser le chemin vers le fichier :
```ini
src_file="/path/to/dbname.sql.7z"
```

On prendra le soin de préciser si le fichier est compressé :
```ini
compress=1
```

***Remarque***

Si __src_type__ est `local_base` ou `remote_base`, le paramètre __compress__ prend un sens différent. Il indique si on souhaite activer ou non la compression à la volée.

***Options la synchronisation SQL***

```ini
sql_ignores="--ignore-table=$src_dbname.table1 --ignore-table=$src_dbname.table2 "
sql_options="--default-character-set=utf8"
```

***Options pour la synchronisation des fichiers***

```ini
rsync_options="-uvrpz --exclude /sitesync/ --exclude /stats/ --exclude .git/ --exclude .svn/ --exclude .cvs/ "
```

Fonctionnement
===

* Le script ```./sync``` se connecte en SSH au serveur distant et fait un dump de la base de données, puis le rappatrie en local. Il est compressé pour le transfert (comportement par défaut).
* Le script fait ensuite les chercher remplacer classiques dans le dump ainsi récupéré (typiquement : WWW_ROOT et FILES_ROOT). Le chercher remplacer gère correctement les données sérialisées.
* Optionnellement, le script pourra appliquer des adaptations personnalisées avant l'import.
* Le script importe le dump obtenu.
* Le script synchronise les fichiers.
* Optionnellement, le script pourra appliquer des adaptations personnalisées avant l'import.

Compatibilité
===

Fonctionne sous Linux, Mac, et Windows avec [Cygwin](http://cygwin.com/install.html) (penser à prendre les paquets ssh, mysql, rsync et ncurses... il vous faudra aussi pouvoir exécuter PHP en ligne de commande dans cygwin).

Aide à la configuration pour une installation type Windows + Xampp + Cygwin
---

Finaliser l'installation de cygwin pour notre besoin :

Dans `~/.my.cnf`
```ini
[client]
host=127.0.0.1
user=root
password=
```

Dans `~/.bash_profile`
```bash
export PATH=$PATH:/cygdrive/c/xampp/mysql/bin:/cygdrive/c/xampp/php
```

```bash
source ~/.bash_profile
ssh-keygen -A
```

Pour Xampp, afin que l'import du dump SQL se déroule bien, il peut être nécessaire de modifier la configuration de mysql (fichier `my.ini`, section `[mysqld]`) : 
```ini
innodb_buffer_pool_size = 32M
max_allowed_packet = 32M
innodb_log_file_size = 32M
```

***Remarque*** : `sitesync` embarque déjà dans son dossier ```/bin``` l'outil [resilient_replace](https://github.com/pa-de-solminihac/resilient_replace) pour faire des chercher-remplacer sans casser les données sérialisées.
