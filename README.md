Sitesync
===

***Synchronise un site local avec un site distant.***

Configuration
---

L'outil a besoin d'un fichier de configuration pour fonctionner. On peut se baser sur le fichier `config-sample` fourni :
```bash
cp etc/config-sample etc/config
```

Il faut ensuite éditer le fichier `etc/config` pour l'adapter à notre besoin.

```bash
vim etc/config
```

Pour ne pas avoir à saisir le mot de passe SSH à chaque fois, utiliser l'accès SSH par clés :

```bash
$ ssh-copy-id user@server
```

Vous pouvez ajouter des scripts à appliquer avant / après l'import de la base de données dans les dossiers `/hook/before` et `hook/after`. À titre d'exemple, des hooks pour Prestashop 1.6 sont présents. 

__Important__ : il faut renommer les scripts hook en leur donnant l'extension `.sh` pour qu'ils soient pris en compte !

Utilisation
---

Une fois la configuration effectuées, il suffit de lancer le script sync :

```bash
$ ./sync
```

***Astuce*** : Si votre clé SSH est protégée par mot de passe et que vous êtes en SSH, pensez à :

```bash
$ eval "$(ssh-agent)"
```

Fonctionnement
---

* Le script ```./sync``` se connecte en SSH au serveur distant et fait un dump de la base de données (compressé à la volée, téléchargé puis décompressé à la volée).
* Il fait ensuite les chercher remplacer classiques dans le dump ainsi récupéré (typiquement : WWW_ROOT et FILES_ROOT) pour adapter la base de données à l'hébergement local. Le chercher remplacer gère correctement les données sérialisées.
* S'il est configuré pour, le script appliquera des adaptations personnalisées avant/après l'import. Il pourra ainsi synchroniser également les fichiers.
* Enfin, le script importe la base de données ainsi mise à jour.

Compatibilité
---

Fonctionne sous Linux, Mac, et Windows avec [Cygwin](http://cygwin.com/install.html) (penser à prendre les paquets ssh, mysql, rsync...).

***Remarque*** : sitesync embarque déjà dans son dossier ```/bin``` l'outil [resilient_replace](https://github.com/pa-de-solminihac/resilient_replace) pour faire des chercher-remplacer sans casser les données sérialisées.
