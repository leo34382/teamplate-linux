#!/bin/bash

echo "Je ping pas, que faire ?"
echo "Ce script vous guide en cas de problème de connexion Internet en suivant le modèle OSI."

# Vérification de la connectivité Internet
ping -c 4 google.com > /dev/null

if [ $? -eq 0 ]; then
  echo "La connexion Internet fonctionne correctement. Rien à faire."
  exit 0
fi

echo "OSI 1 : Vérification physique (couches 1 et 2)"
echo "1) Est-ce que le câble réseau est branché ? Est-ce que la carte réseau est activée ?"

# Vérification de la carte réseau
if [[ $(ip link) == *UP* ]]; then
  echo "La carte réseau est activée."
else
  echo "La carte réseau n'est pas activée. Activez-la avec la commande 'ip link set dev <interface> up'."
fi

# Vérification du câble réseau
ping -c 4 google.com > /dev/null
if [ $? -eq 0 ]; then
  echo "La connexion Internet est rétablie. Si la carte était désactivée, le problème est résolu."
  exit 0
fi

echo "OSI 2 : Vérification liaison de données (couches 2 et 3)"
echo "2) Est-ce que la carte réseau est branchée dans le bon switch ?"

# Vérification du switch (dans ce script, nous passons à l'étape suivante sans action spécifique)

echo "OSI 3 : Vérification réseau (couches 3 et 4)"
echo "3) Est-ce que la carte a une IP dans le bon sous-réseau ?"
echo "4) Est-ce que la machine a une passerelle ?"

# Vérification des paramètres IP
if [[ $(ip address) == *192.168.100.0/24* ]]; then
  echo "La carte a une IP dans le bon sous-réseau (192.168.100.0/24)."
  if [[ $(ip route) == *default via 192.168.100.1* ]]; then
    echo "La machine a une passerelle configurée."
  else
    echo "La machine n'a pas de passerelle configurée. Configurez-la avec la commande 'ip route add default via <passerelle>'."
  fi
else
  echo "La carte n'a pas d'IP dans le bon sous-réseau (192.168.100.0/24). Configurez-la avec 'ip address add <ip>/<masque> dev <interface>'."
fi

# Si aucune étape n'a résolu le problème
ping -c 4 google.com > /dev/null
if [ $? -eq 0 ]; then
  echo "La connexion Internet est rétablie après avoir suivi les étapes de dépannage."
  exit 0
fi

echo "Le problème de connexion Internet persiste. Veuillez contacter votre fournisseur d'accès Internet pour obtenir de l'aide."

exit 1
