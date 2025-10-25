# 🤖 Projet Robot Éducatif - Vue d'Ensemble

## 📁 Structure du Projet

```
windsurf-project-4/
│
├── 📄 README.md                    # Documentation principale
├── 📄 GUIDE_DEMARRAGE.md          # Guide de démarrage rapide
├── 📄 PROJET_COMPLET.md           # Ce fichier
│
├── 🔧 requirements.txt             # Dépendances Python
├── 🔧 install.sh                   # Installation Linux/Mac
├── 🔧 install.bat                  # Installation Windows
│
├── 🐍 robot_smile.py              # ⭐ PROGRAMME PRINCIPAL - Sourire Cozmo
├── 🐍 roboeyes_pygame.py          # Bibliothèque yeux pour Pygame
│
├── 📂 examples/                    # Exemples supplémentaires
│   ├── emotions.py                # Démonstration des émotions
│   └── interactive.py             # Contrôle interactif complet
│
└── 📂 micropython/                 # Version pour robot réel
    ├── README.md                  # Guide matériel
    ├── main.py                    # Programme principal MicroPython
    └── roboeyes.py                # Bibliothèque pour MicroPython
```

## 🎯 Objectif du Projet

Créer un robot éducatif avec des yeux expressifs (style Cozmo) pour apprendre :
- **Programmation Python** : Variables, fonctions, boucles, événements
- **Graphiques** : Dessiner et animer à l'écran
- **Électronique** : Connecter des composants (version matérielle)
- **Logique** : Résoudre des problèmes et déboguer

## 🚀 Démarrage Rapide (3 étapes)

### 1️⃣ Installation
```bash
# Linux/Mac
./install.sh

# Windows
install.bat

# Ou manuellement
pip install pygame numpy
```

### 2️⃣ Lancer le Programme Principal
```bash
python3 robot_smile.py
```

### 3️⃣ Interagir
- **ESPACE** : Faire sourire le robot 😊
- **O** : Ouvrir les yeux 👀
- **C** : Fermer les yeux 😴
- **B** : Cligner 😉
- **ESC** : Quitter

## 📚 Programmes Disponibles

### 1. robot_smile.py (Débutant) ⭐
**Le programme principal !** Un robot qui sourit comme Cozmo.

**Fonctionnalités :**
- Yeux animés avec clignement automatique
- Sourire activable avec la touche ESPACE
- Contrôles simples au clavier
- Interface visuelle agrandie (512x256)

**Parfait pour :** Première découverte, démonstration

### 2. examples/emotions.py (Intermédiaire)
Démonstration automatique de toutes les émotions.

**Émotions disponibles :**
- 😐 Normal (DEFAULT)
- 😊 Heureux (HAPPY)
- 😴 Fatigué (TIRED)
- 😠 En colère (ANGRY)

**Parfait pour :** Comprendre les différentes expressions

### 3. examples/interactive.py (Avancé)
Contrôle complet du robot avec le clavier.

**Commandes :**
- **1-4** : Changer d'émotion
- **O/C** : Ouvrir/Fermer les yeux
- **B** : Cligner
- **A** : Toggle clignement automatique
- **+/-** : Agrandir/réduire les yeux

**Parfait pour :** Expérimentation et personnalisation

### 4. micropython/main.py (Expert)
Version pour robot réel avec écran OLED.

**Matériel requis :**
- Raspberry Pi Pico ou ESP32
- Écran OLED I2C 128x64 (SSD1306)
- Câbles de connexion

**Parfait pour :** Créer un vrai robot physique

## 🎓 Parcours d'Apprentissage

### Niveau 1 : Découverte (1-2 heures)
1. ✅ Installer le projet
2. ✅ Lancer `robot_smile.py`
3. ✅ Tester toutes les touches
4. ✅ Lancer `examples/emotions.py`
5. ✅ Observer les différentes expressions

### Niveau 2 : Exploration (2-4 heures)
1. ✅ Lancer `examples/interactive.py`
2. ✅ Tester toutes les combinaisons
3. ✅ Ouvrir `robot_smile.py` dans un éditeur
4. ✅ Lire les commentaires dans le code
5. ✅ Identifier les différentes parties du programme

### Niveau 3 : Modification (4-8 heures)
1. ✅ Changer la taille des yeux dans le code
2. ✅ Modifier la vitesse de clignement
3. ✅ Ajouter une nouvelle touche au clavier
4. ✅ Créer une nouvelle séquence d'émotions
5. ✅ Personnaliser les couleurs (version Pygame)

### Niveau 4 : Création (8+ heures)
1. ✅ Créer son propre programme
2. ✅ Ajouter de nouvelles fonctionnalités
3. ✅ Assembler le matériel pour la version physique
4. ✅ Programmer le robot réel
5. ✅ Inventer de nouveaux comportements

## 🔧 Technologies Utilisées

### Version Simulation (PC)
- **Python 3.7+** : Langage de programmation
- **Pygame** : Bibliothèque graphique
- **NumPy** : Calculs mathématiques

### Version Matérielle (Robot)
- **MicroPython** : Python pour microcontrôleurs
- **SSD1306** : Driver pour écran OLED
- **FrameBuffer** : Gestion de l'affichage

## 📖 Code Source Original

Ce projet est basé sur :
- **micropython-roboeyes** par MCHobby
- GitHub : https://github.com/mchobby/micropython-roboeyes
- Adapté et simplifié pour l'apprentissage

## 🎨 Personnalisations Possibles

### Facile
- ✅ Changer la taille des yeux
- ✅ Modifier la vitesse de clignement
- ✅ Ajouter des touches au clavier
- ✅ Changer les couleurs de fond

### Moyen
- ✅ Créer de nouvelles émotions
- ✅ Ajouter des sons
- ✅ Faire suivre la souris
- ✅ Créer des séquences d'animation

### Difficile
- ✅ Ajouter des capteurs (distance, son)
- ✅ Interface web de contrôle
- ✅ Reconnaissance vocale
- ✅ Communication entre robots

## 🐛 Résolution de Problèmes

### Problème : "ModuleNotFoundError: No module named 'pygame'"
**Solution :** Exécutez `pip install pygame`

### Problème : "python: command not found"
**Solution :** Utilisez `python3` au lieu de `python`

### Problème : L'écran reste noir
**Solution :** Appuyez sur 'O' pour ouvrir les yeux

### Problème : Le robot ne cligne pas
**Solution :** Attendez quelques secondes ou appuyez sur 'B'

### Problème : Erreur I2C (version MicroPython)
**Solution :** Vérifiez les connexions SDA/SCL

## 💡 Idées de Projets Avancés

1. **Robot Réveil** : Affiche l'heure et se réveille progressivement
2. **Compagnon d'Étude** : Encourage pendant les devoirs
3. **Détecteur de Présence** : Réagit quand quelqu'un s'approche
4. **Station Météo** : Affiche la météo avec des expressions
5. **Jeu Interactif** : Devine l'émotion affichée
6. **Robot Messager** : Affiche des notifications
7. **Tamagotchi Robotique** : Animal virtuel à nourrir
8. **Indicateur de Concentration** : Aide à rester concentré

## 🤝 Contribuer et Partager

### Partagez vos créations !
- Prenez des photos/vidéos
- Documentez vos modifications
- Créez des tutoriels
- Aidez d'autres apprenants

### Améliorations possibles
- Nouvelles émotions
- Meilleurs graphismes
- Plus d'animations
- Support de nouveaux matériels

## 📞 Support

### Documentation
- `README.md` : Vue d'ensemble
- `GUIDE_DEMARRAGE.md` : Guide détaillé
- `micropython/README.md` : Version matérielle
- Commentaires dans le code

### Ressources Externes
- [Documentation Pygame](https://www.pygame.org/docs/)
- [MicroPython](https://docs.micropython.org/)
- [Projet original](https://github.com/mchobby/micropython-roboeyes)

## 🎉 Conclusion

Ce projet est conçu pour être :
- ✅ **Éducatif** : Apprendre en s'amusant
- ✅ **Progressif** : Du simple au complexe
- ✅ **Pratique** : De la simulation au robot réel
- ✅ **Créatif** : Infiniment personnalisable

**Amusez-vous bien et bon apprentissage ! 🚀🤖**

---

*Créé avec ❤️ pour apprendre la programmation et l'électronique*
