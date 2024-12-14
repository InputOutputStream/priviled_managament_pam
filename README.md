# README : Script de Sécurisation PAM et Verrouillage des Tentatives de Connexion

## Description

Ce script Bash permet de renforcer la sécurité d'un système Linux en configurant les paramètres PAM (Pluggable Authentication Modules) pour limiter les tentatives de connexion infructueuses, définir un délai de verrouillage après plusieurs échecs, et appliquer des règles de complexité de mot de passe.

---

## Fonctionnalités

1. **Limitation des tentatives de connexion :**  
   - Nombre maximum de tentatives infructueuses : 3  
   - Verrouillage temporaire après 3 échecs : 60 secondes  

2. **Configuration du délai d'attente :**  
   - Intervalle d'accumulation des échecs : 90 secondes  

3. **Complexité des mots de passe :**  
   - Longueur minimale : 8 caractères  
   - Nombre de différences minimales avec le mot de passe précédent : 3  
   - Nombre maximal de tentatives de saisie : 3  

4. **Sauvegarde automatique :**  
   - Les fichiers système modifiés (`common-auth`, `faillock.conf`) sont sauvegardés avant toute modification.

5. **Redémarrage du service SSH :**  
   - Le script redémarre le service `sshd` pour appliquer les modifications.

---

## Prérequis

- **Système Linux basé sur PAM** (ex. Ubuntu/Debian).  
- **Accès root** : Ce script doit être exécuté en tant qu'utilisateur root.

---

## Utilisation

1. **Télécharger le script :**  
   Enregistrez le contenu du script dans un fichier, par exemple `pam.sh`.

2. **Rendre le script exécutable :**  
   ```bash
   chmod +x secure_pam.sh
   ```

