#!/bin/bash

# Emplacement du fichier de journal SSH (peut varier selon la distribution)
if [ -f "/var/log/auth.log" ]; then
    auth_log="/var/log/auth.log"      # Debian/Ubuntu
elif [ -f "/var/log/secure" ]; then
    auth_log="/var/log/secure"        # CentOS/RHEL
elif [ -f "/var/log/auth.log" ]; then
    auth_log="/var/log/auth.log"      # Arch Linux
else
    echo "Le fichier de journal SSH n'a pas été trouvé. Veuillez adapter le script à votre distribution."
    exit 1
fi

# Emplacement du fichier de journal personnalisé
custom_log="/var/log/ssh_connections.log"

# Emplacement du fichier de journal des connexions échouées
failed_log="/var/log/ssh_failed.log"

# Vérifier si l'utilisateur a les autorisations nécessaires (doit être exécuté en tant que superutilisateur)
if [ "$(id -u)" != 0 ]; then
  echo "Ce script doit être exécuté en tant que superutilisateur (root)."
  exit 1
fi

# Vérifier si le fichier de journal personnalisé existe
if [ ! -f "$custom_log" ]; then
  touch "$custom_log"
fi

# Vérifier si le fichier de journal des connexions échouées existe
if [ ! -f "$failed_log" ]; then
  touch "$failed_log"
fi

# Fonction pour journaliser une connexion SSH
log_ssh_connection() {
  local log_entry
  log_entry="$(date '+%Y-%m-%d %H:%M:%S') - $1 $2 ($3)"
  echo "$log_entry" >> "$custom_log"
}

# Fonction pour journaliser une tentative de connexion échouée
log_failed_connection() {
  local log_entry
  log_entry="$(date '+%Y-%m-%d %H:%M:%S') - $1 ($2)"
  echo "$log_entry" >> "$failed_log"
}

# Surveiller le fichier de journal SSH en temps réel
tail -n0 -F "$auth_log" | while read line; do
  if echo "$line" | grep -qE "sshd\[[0-9]+\]: Accepted publickey|sshd\[[0-9]+\]: Accepted password"; then
    log_ssh_connection "$(echo "$line" | awk '{print $6}')" "$(echo "$line" | awk '{print $8}')" "$(echo "$line" | awk '{print $9}')"
  elif echo "$line" | grep -qE "sshd\[[0-9]+\]: Failed password"; then
    log_failed_connection "$(echo "$line" | awk '{print $6}')" "$(echo "$line" | awk '{print $9}')"
  fi
done
