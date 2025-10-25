# 🤖 Projet Robot Éducatif - Yeux Animés

Un projet pour apprendre la programmation et l'électronique avec votre enfant en créant un robot avec des yeux expressifs comme Cozmo !

## 📋 Description

Ce projet permet de créer un robot avec des yeux animés qui peuvent exprimer différentes émotions. Il est basé sur le projet [micropython-roboeyes](https://github.com/mchobby/micropython-roboeyes) et adapté pour être facile à comprendre et à modifier.

## 🎯 Objectifs Pédagogiques

- **Programmation Python** : Apprendre les bases de Python
- **Graphiques** : Comprendre comment dessiner à l'écran
- **Animations** : Créer des mouvements fluides
- **Électronique** : Connecter un écran OLED (pour la version matérielle)

## 🚀 Démarrage Rapide

### Version Simulation (sur PC)

1. **Installer les dépendances** :
```bash
pip install -r requirements.txt
```

2. **Lancer le programme de démonstration** :
```bash
python robot_smile.py
```

### Version MicroPython (pour le vrai robot)

Voir le dossier `micropython/` pour les instructions détaillées.

## 📁 Structure du Projet

```
windsurf-project-4/
├── README.md                 # Ce fichier
├── requirements.txt          # Dépendances Python
├── robot_smile.py           # Programme principal - sourire Cozmo
├── roboeyes_pygame.py       # Bibliothèque d'yeux pour Pygame
├── micropython/             # Version pour MicroPython
│   ├── README.md
│   ├── roboeyes.py          # Code adapté du projet original
│   └── main.py              # Programme principal pour le robot
└── examples/                # Exemples supplémentaires
    ├── emotions.py          # Différentes émotions
    └── interactive.py       # Contrôle interactif
```

## 🎨 Fonctionnalités

- ✅ Yeux animés avec clignement automatique
- ✅ Différentes émotions (heureux, triste, en colère, curieux)
- ✅ Sourire style Cozmo
- ✅ Mouvements fluides et naturels
- ✅ Facile à personnaliser

## 🛠️ Matériel Nécessaire (pour la version robot)

- Raspberry Pi Pico ou ESP32
- Écran OLED I2C 128x64 (SSD1306)
- Câbles de connexion
- Alimentation

## 📚 Ressources

- [Projet original micropython-roboeyes](https://github.com/mchobby/micropython-roboeyes)
- [Documentation Pygame](https://www.pygame.org/docs/)
- [MicroPython](https://micropython.org/)

## 👨‍👦 Pour les Parents

Ce projet est conçu pour être progressif :
1. Commencez par exécuter les exemples
2. Modifiez les paramètres (taille des yeux, couleurs)
3. Créez de nouvelles expressions
4. Passez à la version matérielle

## 📝 Licence

Basé sur le projet RoboEyes original. Code éducatif libre d'utilisation.
