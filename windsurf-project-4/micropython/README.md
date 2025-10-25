# 🤖 Version MicroPython pour Robot Réel

Cette version est conçue pour fonctionner sur un vrai robot avec un écran OLED.

## 🛠️ Matériel Nécessaire

- **Microcontrôleur** : Raspberry Pi Pico, ESP32, ou ESP8266
- **Écran OLED** : SSD1306 I2C 128x64 pixels
- **Câbles** : 4 câbles de connexion (VCC, GND, SDA, SCL)
- **Alimentation** : Batterie ou câble USB

## 🔌 Branchement de l'Écran OLED

### Pour Raspberry Pi Pico

```
OLED SSD1306    →    Raspberry Pi Pico
─────────────────────────────────────
VCC (3.3V)      →    3V3 (Pin 36)
GND             →    GND (Pin 38)
SDA             →    GP6 (Pin 9)
SCL             →    GP7 (Pin 10)
```

### Pour ESP32

```
OLED SSD1306    →    ESP32
──────────────────────────
VCC (3.3V)      →    3V3
GND             →    GND
SDA             →    GPIO 21
SCL             →    GPIO 22
```

## 📦 Installation

### 1. Installer MicroPython sur votre carte

Suivez les instructions sur [micropython.org](https://micropython.org/download/)

### 2. Installer les bibliothèques nécessaires

Connectez-vous à votre carte via USB et utilisez `mpremote` :

```bash
# Installer la bibliothèque SSD1306
mpremote mip install ssd1306

# Copier les fichiers du projet
mpremote fs cp roboeyes.py :lib/roboeyes.py
mpremote fs cp main.py :main.py
```

Ou manuellement avec Thonny IDE :
1. Ouvrez Thonny
2. Connectez-vous à votre carte
3. Copiez `roboeyes.py` dans le dossier `/lib/`
4. Copiez `main.py` à la racine

### 3. Lancer le programme

Le fichier `main.py` se lance automatiquement au démarrage de la carte.

Pour tester immédiatement :
```python
# Dans le REPL MicroPython
import main
```

## 🎓 Exercices pour Apprendre

### Niveau Débutant
1. **Changer la vitesse de clignement** : Modifiez les paramètres dans `set_auto_blinker()`
2. **Changer la taille des yeux** : Utilisez `eyes_width()` et `eyes_height()`

### Niveau Intermédiaire
3. **Ajouter des boutons** : Connectez des boutons pour changer l'expression
4. **Séquence d'émotions** : Créez une boucle qui change d'humeur toutes les 5 secondes

### Niveau Avancé
5. **Capteur de distance** : Faites réagir le robot quand quelqu'un s'approche
6. **Reconnaissance vocale** : Utilisez un module micro pour réagir aux sons

## 📚 Code Source Original

Ce projet est basé sur :
- [micropython-roboeyes](https://github.com/mchobby/micropython-roboeyes) par MCHobby

## 🐛 Dépannage

### L'écran ne s'allume pas
- Vérifiez les connexions (VCC, GND, SDA, SCL)
- Vérifiez l'adresse I2C (0x3C ou 0x3D)
- Testez avec : `i2c.scan()` dans le REPL

### Erreur "OSError: [Errno 2] ENOENT"
- Vérifiez que les fichiers sont bien copiés
- `roboeyes.py` doit être dans `/lib/`

### L'animation est saccadée
- Réduisez le `frame_rate` dans le code
- Vérifiez que votre carte n'est pas surchargée

## 💡 Idées de Projets

1. **Robot de bureau** : Réagit quand vous vous approchez
2. **Réveil mignon** : Affiche différentes expressions selon l'heure
3. **Indicateur de notifications** : Cligne quand vous recevez un message
4. **Compagnon d'apprentissage** : Encourage votre enfant pendant ses devoirs
