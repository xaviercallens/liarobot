# 🎓 Exercices pour Apprendre

Des exercices progressifs pour maîtriser la programmation avec le robot !

## 🟢 Niveau Débutant (7-10 ans)

### Exercice 1 : Exploration
**Objectif :** Se familiariser avec le programme

**À faire :**
1. Lance `robot_smile.py`
2. Appuie sur toutes les touches et note ce qui se passe
3. Compte combien de fois le robot cligne en 1 minute

**Questions :**
- Quelle touche fait sourire le robot ?
- Que se passe-t-il quand tu appuies sur 'O' ?
- Le robot cligne-t-il toujours au même moment ?

### Exercice 2 : Modification Simple
**Objectif :** Faire sa première modification

**À faire :**
1. Ouvre `robot_smile.py` dans un éditeur de texte
2. Trouve la ligne avec `frame_rate=30`
3. Change 30 en 60
4. Sauvegarde et relance le programme

**Questions :**
- Qu'est-ce qui a changé ?
- Pourquoi le robot bouge différemment ?

### Exercice 3 : Changer les Tailles
**Objectif :** Comprendre les paramètres

**À faire :**
1. Dans `robot_smile.py`, trouve la ligne `RoboEyes(oled_surface, 128, 64, frame_rate=30)`
2. Juste après, ajoute cette ligne :
   ```python
   robo.eyes_width(40, 40)
   ```
3. Sauvegarde et teste

**Défi :** Essaie différentes valeurs (20, 30, 50)

---

## 🟡 Niveau Intermédiaire (10-13 ans)

### Exercice 4 : Nouvelle Touche
**Objectif :** Ajouter une fonctionnalité

**À faire :**
1. Ouvre `robot_smile.py`
2. Trouve la section avec `elif event.key == pygame.K_SPACE:`
3. Ajoute ce code après :
   ```python
   elif event.key == pygame.K_t:
       print("😴 Le robot est fatigué")
       robo.set_mood(1)  # TIRED
   ```

**Défi :** Ajoute des touches pour toutes les émotions (0-6)

### Exercice 5 : Séquence d'Émotions
**Objectif :** Créer une animation automatique

**À faire :**
Crée un nouveau fichier `mon_robot.py` :

```python
import pygame
import sys
import time
from roboeyes_pygame import RoboEyes, HAPPY, TIRED, ON

pygame.init()
screen = pygame.display.set_mode((512, 256))
oled_surface = pygame.Surface((128, 64))
robo = RoboEyes(oled_surface, 128, 64, frame_rate=30)

robo.open_eyes()
clock = pygame.time.Clock()

# Ta séquence ici !
emotions = [0, 3, 1, 2, 3]  # Normal, Heureux, Fatigué, Colère, Heureux
emotion_index = 0
last_change = time.time()

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.USEREVENT + 1:
            robo.open_eyes()
    
    # Changer d'émotion toutes les 2 secondes
    if time.time() - last_change > 2:
        robo.set_mood(emotions[emotion_index])
        emotion_index = (emotion_index + 1) % len(emotions)
        last_change = time.time()
    
    robo.update()
    scaled = pygame.transform.scale(oled_surface, (512, 256))
    screen.blit(scaled, (0, 0))
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
```

**Défi :** Crée ta propre séquence d'émotions !

### Exercice 6 : Compteur de Clics
**Objectif :** Utiliser des variables

**À faire :**
Modifie `robot_smile.py` pour compter les sourires :

1. Ajoute au début (après `is_smiling = False`) :
   ```python
   smile_count = 0
   ```

2. Dans la section ESPACE, ajoute :
   ```python
   smile_count += 1
   print(f"Nombre de sourires : {smile_count}")
   ```

**Défi :** Affiche le compteur à l'écran avec Pygame

---

## 🔴 Niveau Avancé (13+ ans)

### Exercice 7 : Suivre la Souris
**Objectif :** Interaction avec la souris

**À faire :**
Modifie `roboeyes_pygame.py` pour ajouter une fonction `look_at(x, y)` qui déplace les yeux vers une position.

**Indice :** Regarde le fichier `robot_eye.py` pour inspiration

### Exercice 8 : Ajouter des Sons
**Objectif :** Multimédia

**À faire :**
1. Télécharge des sons (bip, clic, etc.)
2. Ajoute dans `robot_smile.py` :
   ```python
   pygame.mixer.init()
   blink_sound = pygame.mixer.Sound("blink.wav")
   ```
3. Joue le son quand le robot cligne

### Exercice 9 : Interface Graphique
**Objectif :** Créer des boutons

**À faire :**
Crée des boutons cliquables pour contrôler le robot :

```python
# Définir des rectangles pour les boutons
button_happy = pygame.Rect(10, 10, 100, 40)
button_tired = pygame.Rect(120, 10, 100, 40)

# Dans la boucle d'événements
if event.type == pygame.MOUSEBUTTONDOWN:
    if button_happy.collidepoint(event.pos):
        robo.set_mood(HAPPY)
    elif button_tired.collidepoint(event.pos):
        robo.set_mood(TIRED)

# Dessiner les boutons
pygame.draw.rect(screen, (0, 200, 0), button_happy)
pygame.draw.rect(screen, (0, 0, 200), button_tired)
```

### Exercice 10 : Mode Aléatoire
**Objectif :** Utiliser le hasard

**À faire :**
Crée un mode où le robot change d'émotion aléatoirement :

```python
import random

# Dans la boucle principale
if random.random() < 0.01:  # 1% de chance à chaque frame
    random_mood = random.randint(0, 3)
    robo.set_mood(random_mood)
```

---

## 🏆 Projets Finaux

### Projet 1 : Robot Tamagotchi
Crée un robot qui :
- A une barre de "bonheur" qui diminue
- Sourit quand tu le "nourris" (touche F)
- Devient triste si tu ne t'en occupes pas
- Cligne plus vite quand il est content

### Projet 2 : Jeu de Devinettes
Crée un jeu où :
- Le robot affiche une émotion aléatoire
- Tu dois deviner quelle émotion (touches 1-4)
- Le robot sourit si tu as bon, se fâche si tu as faux
- Compte les points

### Projet 3 : Robot Réveil
Crée un réveil qui :
- Affiche l'heure actuelle
- Ferme les yeux la nuit (après 22h)
- Se réveille progressivement le matin
- Sourit quand c'est le week-end

### Projet 4 : Station Météo
Connecte-toi à une API météo et :
- Affiche le soleil (heureux) s'il fait beau
- Affiche la pluie (triste) s'il pleut
- Cligne plus vite s'il y a du vent
- Change la taille des yeux selon la température

---

## 🎯 Défis Bonus

### Défi 1 : Mini-Jeu
Crée un jeu où tu dois cliquer sur le robot quand il sourit

### Défi 2 : Mode Nuit
Ajoute un fond noir et des yeux qui brillent dans le noir

### Défi 3 : Émotions Personnalisées
Invente 3 nouvelles émotions (surpris, amoureux, confus)

### Défi 4 : Contrôle Vocal
Utilise un micro pour que le robot réagisse aux sons

### Défi 5 : Multi-Robots
Affiche plusieurs robots qui interagissent entre eux

---

## 📝 Conseils pour Réussir

### Pour les Exercices
1. ✅ Lis bien la consigne
2. ✅ Teste le code avant de modifier
3. ✅ Fais une modification à la fois
4. ✅ Sauvegarde avant de tester
5. ✅ N'aie pas peur des erreurs !

### Pour Déboguer
1. ✅ Lis le message d'erreur
2. ✅ Vérifie la ligne indiquée
3. ✅ Compare avec le code qui marche
4. ✅ Demande de l'aide si besoin
5. ✅ Utilise `print()` pour voir les valeurs

### Pour Progresser
1. ✅ Fais un exercice par jour
2. ✅ Reviens sur les anciens exercices
3. ✅ Explique ton code à quelqu'un
4. ✅ Invente tes propres exercices
5. ✅ Partage tes créations !

---

## 🌟 Tableau de Progression

Coche les exercices réussis :

- [ ] Exercice 1 : Exploration
- [ ] Exercice 2 : Modification Simple
- [ ] Exercice 3 : Changer les Tailles
- [ ] Exercice 4 : Nouvelle Touche
- [ ] Exercice 5 : Séquence d'Émotions
- [ ] Exercice 6 : Compteur de Clics
- [ ] Exercice 7 : Suivre la Souris
- [ ] Exercice 8 : Ajouter des Sons
- [ ] Exercice 9 : Interface Graphique
- [ ] Exercice 10 : Mode Aléatoire
- [ ] Projet Final 1
- [ ] Projet Final 2
- [ ] Projet Final 3
- [ ] Projet Final 4

**Score :** ___/14

---

## 🎓 Certificat de Réussite

Quand tu as terminé tous les exercices, tu peux te créer un certificat :

```
╔═══════════════════════════════════════════╗
║                                           ║
║     🏆 CERTIFICAT DE PROGRAMMEUR 🏆       ║
║                                           ║
║         [Ton Nom]                         ║
║                                           ║
║   A réussi tous les exercices du          ║
║   Projet Robot Éducatif                   ║
║                                           ║
║   Compétences acquises :                  ║
║   ✅ Programmation Python                 ║
║   ✅ Graphiques et Animations             ║
║   ✅ Logique et Débogage                  ║
║   ✅ Créativité et Innovation             ║
║                                           ║
║   Date : _______________                  ║
║                                           ║
╚═══════════════════════════════════════════╝
```

**Bravo et continue à coder ! 🚀🤖**
