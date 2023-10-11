#!/bin/bash

echo "Bienvenue dans l'installateur interactif de paquets!"
echo "Sélectionnez les paquets que vous souhaitez installer par catégorie :"

# Vérifier si l'utilisateur est root
if [ "$(id -u)" != 0 ]; then
  use_sudo="sudo"
else
  use_sudo=""
fi

# Déterminer le gestionnaire de paquets utilisé sur le système
if [ -x "$(command -v apt-get)" ]; then
  package_manager="apt-get"
elif [ -x "$(command -v apt)" ]; then
  package_manager="apt"
elif [ -x "$(command -v dnf)" ]; then
  package_manager="dnf"
elif [ -x "$(command -v yum)" ]; then
  package_manager="yum"
else
  echo "Aucun gestionnaire de paquets pris en charge n'a été trouvé sur votre système."
  exit 1
fi

# Définir des tableaux associatifs pour les catégories et les paquets
declare -A categories
declare -A packages

# Catégories de paquets
categories["1"]="Utilitaires système"
categories["2"]="Outils de développement"
categories["3"]="Navigation sur le Web"
categories["4"]="Édition de texte"
categories["5"]="Multimédia"
categories["6"]="Sécurité"
categories["7"]="Autres"

# Paquets disponibles par catégorie
packages["1,1"]="htop (gestionnaire de tâches en mode texte)"
packages["1,2"]="tree (afficher la structure des répertoires en arbre)"
packages["1,3"]="curl (outil de transfert de données)"
packages["1,4"]="ncdu (analyseur d'utilisation du disque)"
packages["1,5"]="ht (outil de test HTTP)"
packages["2,1"]="vim (éditeur de texte avancé)"
packages["2,2"]="git (système de contrôle de version)"
packages["2,3"]="gcc (compilateur C)"
packages["2,4"]="g++ (compilateur C++)"
packages["2,5"]="python3 (Python 3)"
packages["3,1"]="firefox (navigateur Web)"
packages["3,2"]="chromium (navigateur Web)"
packages["3,3"]="curl (outil de transfert de données)"
packages["3,4"]="filezilla (client FTP)"
packages["3,5"]="thunderbird (client de messagerie)"
packages["4,1"]="nano (éditeur de texte léger)"
packages["4,2"]="emacs (éditeur de texte extensible)"
packages["4,3"]="vscode (Visual Studio Code)"
packages["4,4"]="sublime-text (éditeur de texte Sublime Text)"
packages["4,5"]="gedit (éditeur de texte Gedit)"
packages["5,1"]="vlc (lecteur multimédia)"
packages["5,2"]="audacity (éditeur audio)"
packages["5,3"]="ffmpeg (conversion vidéo/audio)"
packages["5,4"]="gimp (éditeur d'images)"
packages["5,5"]="inkscape (éditeur de vecteurs)"
packages["6,1"]="clamav (antivirus)"
packages["6,2"]="ufw (pare-feu)"
packages["6,3"]="rkhunter (scanner de rootkits)"
packages["6,4"]="openvpn (VPN)"
packages["6,5"]="gnupg (chiffrement)"
packages["7,1"]="fortune (affichage aléatoire de citations)"
packages["7,2"]="cmatrix (économiseur d'écran en mode matrice)"
packages["7,3"]="figlet (générateur de texte ASCII)"
packages["7,4"]="cowsay (affiche un dessin de vache)"
packages["7,5"]="nmap (scanner de réseau)"

# Ajoutez 20 paquets supplémentaires dans les catégories 5, 6 et 7
packages["5,6"]="handbrake (convertisseur vidéo)"
packages["5,7"]="mpv (lecteur multimédia en ligne de commande)"
packages["5,8"]="kdenlive (éditeur vidéo)"
packages["5,9"]="blender (modélisation 3D)"
packages["5,10"]="obs-studio (logiciel de streaming)"
packages["6,6"]="snort (IDS/IPS)"
packages["6,7"]="fail2ban (prévention des intrusions)"
packages["6,8"]="openssl (outil de chiffrement)"
packages["6,9"]="gufw (interface graphique pour UFW)"
packages["6,10"]="rssh (shell restreint)"
packages["7,6"]="cmus (lecteur de musique en ligne de commande)"
packages["7,7"]="httrack (aspirateur de sites Web)"
packages["7,8"]="figlet (générateur de texte ASCII)"
packages["7,9"]="atop (moniteur système avancé)"
packages["7,10"]="xournal (prise de notes manuscrites)"
packages["7,11"]="tor (navigateur anonyme)"
packages["7,12"]="htop (gestionnaire de tâches)"
packages["7,13"]="neofetch (affiche des informations système)"
packages["7,14"]="ranger (gestionnaire de fichiers en ligne de commande)"
packages["7,15"]="gparted (éditeur de partition)"
packages["7,16"]="htop (gestionnaire de tâches)"
packages["7,17"]="neofetch (affiche des informations système)"
packages["7,18"]="ranger (gestionnaire de fichiers en ligne de commande)"
packages["7,19"]="gparted (éditeur de partition)"
packages["7,20"]="glances (surveillance système)"

# Afficher les catégories et les paquets disponibles
for key in "${!categories[@]}"; do
  echo "$key) ${categories[$key]}"
done

# L'utilisateur choisit une catégorie
read -p "Entrez le numéro de la catégorie à installer : " category_choice

# Afficher les paquets de la catégorie choisie
for key in "${!packages[@]}"; do
  if [[ $key == "$category_choice"* ]]; then
    echo "${key#*,}) ${packages[$key]}"
  fi
done

# L'utilisateur choisit les paquets à installer
read -p "Entrez le numéro des paquets à installer (séparés par des espaces, ex. 1 2) : " package_choices

# Mettre à jour la liste des paquets à installer
selected_packages=()
for choice in $package_choices; do
  package_name="${packages[$category_choice,$choice]}"
  if [ -n "$package_name" ]; then
    selected_packages+=("$package_name")
  fi
done

# Vérifier si au moins un paquet a été sélectionné
if [ ${#selected_packages[@]} -eq 0 ]; then
  echo "Aucun paquet sélectionné. L'installation est annulée."
  exit 0
fi

# Demander confirmation à l'utilisateur
echo "Vous avez choisi d'installer les paquets suivants :"
for package in "${selected_packages[@]}"; do
  echo "- $package"
done

read -p "Voulez-vous continuer ? (O/n) : " confirm
if [ "$confirm" != "O" ] && [ "$confirm" != "o" ]; then
  echo "L'installation est annulée."
  exit 0
fi
# Installer les paquets sélectionnés en fonction du gestionnaire de paquets
for package in "${selected_packages[@]}"; do
  case "$package_manager" in
    "apt-get")
      $use_sudo apt-get install $package
      ;;
    "apt")
      $use_sudo apt install $package
      ;;
    "dnf")
      $use_sudo dnf install $package
      ;;
    "yum")
      $use_sudo yum install $package
      ;;
  esac
done

echo "Installation terminée."
