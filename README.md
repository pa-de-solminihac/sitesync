Sitesync
===

***Synchronise un site local avec un site distant.***

Configuration
---

La configuration des accès se fait dans le fichier ```/etc/config```

Afin de ne pas rendre visibles les mots de passe en clair, et pour une utilisation conviviale :

* configurez l'accès SSH par clés :

```bash
$ ssh-copy-id user@server
```

* configurez les fichiers ```.my.cnf``` dans votre dossier ```$HOME``` et dans celui de l'hebergement

```ini
[client]
password=********
```

Vous pouvez ajouter des scripts à appliquer avant / après l'import de la base de données dans le dossier ```/hook```

Utilisation
---

Une fois la configuration effectuées, il suffit de lancer le script sync :

```bash
$ ./sync
```

Fonctionnement
---

* Le script ```./sync``` se connecte en SSH au serveur distant et fait un dump de la base de données (compressé à la volée, téléchargé puis décompressé à la volée).
* Il fait ensuite les chercher remplacer classiques dans le dump ainsi récupéré (typiquement : WWW_ROOT et FILES_ROOT) pour adapter la base de données à l'hébergement local. Le chercher remplacer gère correctement les données sérialisées.
* S'il est configuré pour, le script appliquera des adaptations personnalisées avant/après l'import. Il pourra ainsi synchroniser également les fichiers.
* Enfin, le script importe la base de données ainsi mise à jour.

Compatibilité
---

Fonctionne sous Linux, Windows avec Cygwin, voire Mac (pas retesté depuis un bout de temps...)

***Note*** : ce script utilise resilient_replace, qu'on trouve dans le dossier ```/bin```, et disponible indépendamment sur github :
https://github.com/pa-de-solminihac/resilient_replace
