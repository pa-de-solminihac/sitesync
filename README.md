sitesync
========

Synchronise un site local avec un site distant :

- récupère un dump de la base de données et fait des chercher remplacer (à régler dans le début du script)
- effectue des adaptations personnalisées si nécessaire
- synchronise l'arborescence avec rsync

Ce script utilise resilient_replace, qui doit être placé à ses côtés :
https://github.com/pa-de-solminihac/resilient_replace
