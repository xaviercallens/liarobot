# 🤖 Guide de Démarrage Rapide - Robots

## 🚀 Installation en 2 étapes

### Étape 1: Installer les dépendances

```bash
./install_dependencies.sh
```

Cette commande va:
- ✅ Créer un environnement virtuel Python
- ✅ Installer pygame et numpy
- ✅ Préparer tout pour lancer les robots

### Étape 2: Lancer un robot

**Option A - Menu interactif** (recommandé):
```bash
./launch_menu.sh
```

**Option B - Lancer directement un robot**:
```bash
./launch_robot_emotions.sh     # Robot avec 7 émotions
./launch_robot_eve.sh          # Robot EVE (premium)
./launch_robot_eve_pro.sh      # Robot EVE Pro (avancé)
./launch_robot_smile.sh        # Robot sourire (simple)
./launch_robot_display.sh      # Yeux qui suivent la souris
```

---

## 🎮 Les Différents Robots

### 1. 🎭 Robot Eye Emotions
**Script**: `./launch_robot_emotions.sh`

Le plus interactif! 7 émotions différentes:
- **Touche 1**: 😐 Neutre
- **Touche 2**: 😊 Joyeux (yeux verts)
- **Touche 3**: 😢 Triste (yeux gris)
- **Touche 4**: 😠 Colère (yeux rouges)
- **Touche 5**: 😲 Surpris (yeux jaunes)
- **Touche 6**: 😨 Peur (yeux violets)
- **Touche 7**: 😍 Amour (yeux roses)

Les yeux suivent votre souris!

---

### 2. 🌟 Robot EVE (Premium)
**Script**: `./launch_robot_eve.sh`

Version inspirée du film WALL-E:
- **ESPACE**: 😊 Sourire
- **C**: 😠 Colère
- **D**: 🤢 Dégoût
- **T**: 😢 Triste
- **P**: 😭 Pleurs (avec larmes animées!)
- **R**: 😂 Rire (yeux qui tremblent)
- **0**: 😐 Normal

Contrôles supplémentaires:
- **O**: Ouvrir les yeux
- **F**: Fermer les yeux
- **B**: Cligner
- **A**: Toggle auto-blink

---

### 3. ⭐ Robot EVE PRO (Avancé)
**Script**: `./launch_robot_eve_pro.sh`

Version la plus complète avec menu graphique!
- Menu avec symboles ASCII classiques (:-), >:(, etc.)
- Colère avec yeux ROUGES qui pulsent
- Interface utilisateur améliorée
- Labels et touches visibles

---

### 4. 😊 Robot Smile (Simple)
**Script**: `./launch_robot_smile.sh`

Version de base, parfaite pour débuter:
- **ESPACE**: Faire sourire
- **O**: Ouvrir les yeux
- **C**: Fermer les yeux
- **B**: Cligner

---

### 5. 👁️ Robot Eye Display
**Script**: `./launch_robot_display.sh`

Robot minimaliste:
- Les yeux suivent votre souris
- Cliquez pour faire cligner
- Clignements automatiques

---

## 🛠️ Dépannage

### Problème: "ModuleNotFoundError: No module named 'pygame'"

**Solution**: Installez d'abord les dépendances
```bash
./install_dependencies.sh
```

### Problème: "Permission denied"

**Solution**: Rendez les scripts exécutables
```bash
chmod +x *.sh
```

### Problème: Le robot ne se lance pas

**Solution**: Utilisez l'environnement virtuel
```bash
./venv/bin/python robot_eye_emotions.py
```

---

## 📦 Structure des Fichiers

```
windsurf-project-4/
├── install_dependencies.sh      # Installation des dépendances
├── launch_menu.sh               # Menu principal
├── launch_robot_emotions.sh     # Lancer robot émotions
├── launch_robot_eve.sh          # Lancer robot EVE
├── launch_robot_eve_pro.sh      # Lancer robot EVE Pro
├── launch_robot_smile.sh        # Lancer robot smile
├── launch_robot_display.sh      # Lancer robot display
├── requirements.txt             # Dépendances Python
├── venv/                        # Environnement virtuel (créé par install)
└── robot_*.py                   # Fichiers Python des robots
```

---

## 💡 Conseils

1. **Première utilisation**: Lancez toujours `./install_dependencies.sh` en premier
2. **Menu pratique**: Utilisez `./launch_menu.sh` pour choisir facilement
3. **Test rapide**: Commencez avec `./launch_robot_display.sh` (le plus simple)
4. **Le plus complet**: Essayez `./launch_robot_eve_pro.sh` pour toutes les fonctionnalités

---

## 🎯 Commande Rapide (Tout-en-un)

```bash
# Installation + Lancement du menu
./install_dependencies.sh && ./launch_menu.sh
```

---

## 📚 Documentation Complète

Pour plus de détails, consultez:
- `README.md` - Documentation principale
- `EMOTIONS_GUIDE.md` - Guide des émotions
- `SYMBOLES_ASCII.txt` - Symboles ASCII utilisés
- `AMELIORATIONS_FINALES.txt` - Dernières améliorations

---

**Amusez-vous bien avec les robots! 🤖✨**
