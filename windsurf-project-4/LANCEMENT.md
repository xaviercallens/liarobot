# 🚀 Guide de Lancement du Robot

## 🎯 Solutions Rapides

### Vous avez l'erreur "python: command not found" ?

Utilisez l'une de ces méthodes :

#### ✅ Méthode 1 : Script de lancement (RECOMMANDÉ)

**Linux/Mac :**
```bash
./run_robot.sh
```

**Tous systèmes :**
```bash
python3 run_robot.py
```

#### ✅ Méthode 2 : Environnement virtuel

Si vous avez installé avec pip dans un venv :
```bash
.venv/bin/python robot_smile.py
```

#### ✅ Méthode 3 : Python3 directement

```bash
python3 robot_smile.py
```

---

## 📋 Commandes Disponibles

### Script Bash (Linux/Mac uniquement)

```bash
./run_robot.sh              # Programme principal (sourire)
./run_robot.sh smile        # Programme principal (sourire)
./run_robot.sh emotions     # Démonstration des émotions
./run_robot.sh interactive  # Contrôle interactif
./run_robot.sh eye          # Robot eye simple
```

### Script Python (Tous systèmes)

```bash
python3 run_robot.py              # Programme principal (sourire)
python3 run_robot.py smile        # Programme principal (sourire)
python3 run_robot.py emotions     # Démonstration des émotions
python3 run_robot.py interactive  # Contrôle interactif
python3 run_robot.py eye          # Robot eye simple
```

---

## 🔧 Résolution de Problèmes

### "python: command not found"

**Cause :** Sur Linux/Mac, la commande est `python3` et non `python`

**Solutions :**
1. Utilisez `python3` au lieu de `python`
2. Utilisez les scripts de lancement : `./run_robot.sh` ou `python3 run_robot.py`
3. Utilisez l'environnement virtuel : `.venv/bin/python`

### "Permission denied" sur run_robot.sh

**Solution :**
```bash
chmod +x run_robot.sh
./run_robot.sh
```

### "ModuleNotFoundError: No module named 'pygame'"

**Solution :**
```bash
# Avec l'environnement virtuel
.venv/bin/python -m pip install -r requirements.txt

# Ou globalement
python3 -m pip install -r requirements.txt
```

### L'écran reste noir

**Solution :** Appuyez sur la touche **O** pour ouvrir les yeux du robot

---

## 💡 Exemples d'Utilisation

### Lancer le programme principal
```bash
./run_robot.sh
# ou
python3 run_robot.py
```

### Voir toutes les émotions
```bash
./run_robot.sh emotions
# ou
python3 run_robot.py emotions
```

### Mode interactif complet
```bash
./run_robot.sh interactive
# ou
python3 run_robot.py interactive
```

---

## 🎓 Pour les Débutants

**Étape par étape :**

1. **Ouvrez un terminal** dans le dossier du projet

2. **Vérifiez que vous êtes au bon endroit** :
   ```bash
   ls
   ```
   Vous devriez voir `robot_smile.py`, `run_robot.sh`, etc.

3. **Lancez le robot** :
   ```bash
   ./run_robot.sh
   ```
   
   Si ça ne marche pas, essayez :
   ```bash
   python3 run_robot.py
   ```

4. **Interagissez** :
   - Appuyez sur **ESPACE** pour faire sourire
   - Appuyez sur **O** pour ouvrir les yeux
   - Appuyez sur **ESC** pour quitter

---

## 📚 Commandes Utiles

### Vérifier la version de Python
```bash
python3 --version
```

### Installer les dépendances
```bash
python3 -m pip install -r requirements.txt
```

### Lister les programmes disponibles
```bash
ls *.py
ls examples/*.py
```

### Voir l'aide du script de lancement
```bash
./run_robot.sh help
# ou
python3 run_robot.py help
```

---

## 🌟 Astuce Pro

Créez un alias dans votre `.bashrc` ou `.zshrc` :

```bash
alias robot='cd ~/CascadeProjects/windsurf-project-4 && ./run_robot.sh'
```

Ensuite, lancez simplement :
```bash
robot
```

---

**Besoin d'aide ?** Consultez `GUIDE_DEMARRAGE.md` ou `COMMENCER_ICI.txt`
