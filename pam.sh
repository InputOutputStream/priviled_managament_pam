#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root."
  exit 1
fi

# Variables
PAM_FILE="/etc/pam.d/common-auth"
SECURE_CONF="/etc/security/faillock.conf"

echo "Sauvegarde des fichiers existants..."
cp $PAM_FILE $PAM_FILE.bak
cp $SECURE_CONF $SECURE_CONF.bak

echo "Configuration du nombre maximum de tentatives et du délai d'attente..."

# Ajouter les paramètres pour limiter les tentatives de connexion a 3 avec un delait d'auth de 3s
if ! grep -q "auth required pam_tally2.so" $PAM_FILE; then
  echo "auth required pam_tally2.so deny=3 unlock_time=60 onerr=fail audit" >> $PAM_FILE
  echo "Ajout de la ligne suivante dans $PAM_FILE :"
  echo "auth required pam_tally2.so deny=3 unlock_time=60 onerr=fail audit"
else
  echo "La ligne pam_tally2.so existe déjà dans $PAM_FILE."
fi

echo "Configuration du délai d'attente après un mot de passe erroné..."

# Modifier le fichier faillock.conf pour définir un délai
cat > $SECURE_CONF <<EOL
# Nombre maximum de tentatives avant le verrouillage
deny = 3

# Durée (en secondes) pendant laquelle l'utilisateur est bloqué après des échecs
unlock_time = 60

# Intervalle de temps pour les tentatives échouées (en secondes)
fail_interval = 90
EOL

echo "Activation des paramètres supplémentaires..."
# Modifier /etc/pam.d/common-password pour forcer des mots de passe complexes (exemple supplémentaire)
PAM_PASSWORD_FILE="/etc/pam.d/common-password"
if ! grep -q "pam_pwquality.so" $PAM_PASSWORD_FILE; then
  echo "password requisite pam_pwquality.so retry=3 minlen=8 difok=3" >> $PAM_PASSWORD_FILE
  echo "Ajout de règles de complexité de mot de passe dans $PAM_PASSWORD_FILE."
fi

echo "Configuration terminée. Voici les changements appliqués :"
echo "- Nombre maximum de tentatives : 3"
echo "- Délai d'attente après verrouillage : 60 secondes"
echo "- Intervalle pour accumuler les échecs : 90 secondes"
echo "- Complexité de mot de passe activée."

echo "Redémarrage des services d'authentification..."
service sshd restart

