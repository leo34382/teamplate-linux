#!/bin/bash
echo "Sauvegarde automatique"
source_dir="./"
backup_dir="/chemin/vers/le/dossier/de/sauvegarde"
timestamp=$(date +%Y%m%d%H%M%S)
backup_file="backup_$timestamp.tar.gz"
tar -czvf $backup_dir/$backup_file $source_dir
echo "Sauvegarde terminée : $backup_dir/$backup_file"
