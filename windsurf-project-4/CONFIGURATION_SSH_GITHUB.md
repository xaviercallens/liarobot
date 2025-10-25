# 🔑 Configuration SSH pour GitHub - liarobot

## ✅ Clé SSH créée avec succès!

Une nouvelle clé SSH a été générée spécifiquement pour le dépôt **liarobot**.

---

## 📋 Étape 1: Copier la clé publique

Voici votre clé publique SSH à ajouter sur GitHub:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFgRPeiZENaOCC3V12QB3/ccRfBNThmebOFFhLt6WV55 liarobot@github
```

---

## 🌐 Étape 2: Ajouter la clé sur GitHub

1. **Allez sur GitHub**: https://github.com/settings/keys

2. **Cliquez sur "New SSH key"** (bouton vert en haut à droite)

3. **Remplissez le formulaire**:
   - **Title**: `liarobot - Linux` (ou un nom de votre choix)
   - **Key type**: `Authentication Key`
   - **Key**: Collez la clé ci-dessus (toute la ligne commençant par `ssh-ed25519`)

4. **Cliquez sur "Add SSH key"**

5. **Confirmez avec votre mot de passe GitHub** si demandé

---

## 🧪 Étape 3: Tester la connexion

Une fois la clé ajoutée sur GitHub, testez la connexion:

```bash
ssh -T git@github-liarobot
```

Vous devriez voir:
```
Hi xaviercallens! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 🚀 Étape 4: Utiliser la clé pour push

Maintenant vous pouvez faire des push sans mot de passe:

```bash
git push liarobot master
```

Aucun mot de passe ne sera demandé! 🎉

---

## 📁 Fichiers créés

- **Clé privée**: `~/.ssh/id_ed25519_liarobot` (NE JAMAIS PARTAGER!)
- **Clé publique**: `~/.ssh/id_ed25519_liarobot.pub` (celle à ajouter sur GitHub)
- **Configuration SSH**: `~/.ssh/config` (mise à jour avec la nouvelle clé)

---

## 🔧 Configuration technique

Le dépôt `liarobot` a été configuré pour utiliser SSH:

```bash
# Ancien (HTTPS - demande mot de passe)
https://github.com/xaviercallens/liarobot.git

# Nouveau (SSH - utilise la clé)
git@github-liarobot:xaviercallens/liarobot.git
```

---

## 💡 Commandes utiles

### Voir les remotes configurés
```bash
git remote -v
```

### Push vers liarobot (sans mot de passe)
```bash
git push liarobot master
```

### Push toutes les branches
```bash
git push liarobot --all
```

### Vérifier la connexion SSH
```bash
ssh -T git@github-liarobot
```

---

## 🛡️ Sécurité

- ✅ La clé privée est protégée (permissions 600)
- ✅ Utilisez une clé différente par projet pour plus de sécurité
- ✅ Ne partagez JAMAIS votre clé privée
- ✅ Seule la clé publique doit être ajoutée sur GitHub

---

## 📚 Ressources

- Documentation GitHub SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Gestion des clés SSH: https://github.com/settings/keys

---

**Note**: Une fois la clé ajoutée sur GitHub, tous vos push vers `liarobot` seront automatiques, sans demande de mot de passe! 🚀
