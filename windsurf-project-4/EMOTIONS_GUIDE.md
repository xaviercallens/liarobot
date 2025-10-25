# 🎭 Guide Complet des Émotions - Robot EVE

## 🌟 Version Premium : Robot EVE

Le robot EVE est la version premium avec **toutes les émotions**, un **écran agrandi** (800x600) et des **transitions fluides** à 60 FPS !

### 🚀 Lancer Robot EVE

```bash
./run_robot.sh eve
# ou
python3 run_robot.py eve
# ou directement
python3 robot_eve.py
```

---

## 🎨 Toutes les Émotions Disponibles

### 😊 Sourire (HAPPY)
**Touche : ESPACE**

- Yeux avec sourire en bas
- Expression joyeuse
- Parfait pour montrer la joie

```python
robo.set_mood(HAPPY)
```

---

### 😠 Colère (ANGRY)
**Touche : C**

- Paupières en angle (sourcils froncés)
- Expression agressive
- Yeux plissés vers le bas

```python
robo.set_mood(ANGRY)
```

---

### 🤢 Dégoût (DISGUST)
**Touche : D**

- Combinaison de paupières fatiguées et en colère
- Expression de répulsion
- Yeux mi-clos avec angle

```python
robo.set_mood(DISGUST)
```

---

### 😢 Tristesse (SAD)
**Touche : T**

- Paupières tombantes
- Expression mélancolique
- Yeux mi-fermés

```python
robo.set_mood(SAD)
```

---

### 😭 Pleurs (CRYING)
**Touche : P**

- Comme la tristesse MAIS avec des larmes !
- Larmes qui tombent en continu
- Animation de larmes qui accélèrent
- Très expressif !

```python
robo.set_mood(CRYING)
```

**Animation spéciale :**
- Nouvelles larmes toutes les 500ms
- Larmes qui tombent avec accélération
- Effet réaliste de pleurs

---

### 😂 Rigolade (LAUGHING)
**Touche : R**

- Yeux qui tremblent de gauche à droite
- Clignement rapide
- Expression de fou rire
- Animation dynamique !

```python
robo.set_mood(LAUGHING)
```

**Animation spéciale :**
- Tremblement horizontal des yeux
- Clignement rapide (toutes les 300ms)
- Effet de rire incontrôlable

---

### 😴 Fatigué (TIRED)
**Touche : (pas assignée dans EVE, utilisez interactive.py)**

- Paupières lourdes
- Expression endormie
- Yeux mi-clos

```python
robo.set_mood(TIRED)
```

---

### 😐 Normal (DEFAULT)
**Touche : 0 (zéro)**

- Yeux ouverts normalement
- Expression neutre
- État par défaut

```python
robo.set_mood(DEFAULT)
```

---

## 🎮 Contrôles Complets

### Émotions
| Touche | Émotion | Emoji | Animation Spéciale |
|--------|---------|-------|-------------------|
| ESPACE | Sourire | 😊 | - |
| C | Colère | 😠 | - |
| D | Dégoût | 🤢 | - |
| T | Tristesse | 😢 | - |
| P | Pleurs | 😭 | ✅ Larmes qui tombent |
| R | Rigolade | 😂 | ✅ Yeux qui tremblent |
| 0 | Normal | 😐 | - |

### Contrôles des Yeux
| Touche | Action |
|--------|--------|
| O | Ouvrir les yeux |
| F | Fermer les yeux |
| B | Cligner |
| A | Toggle clignement automatique |

### Système
| Touche | Action |
|--------|--------|
| ESC | Quitter |

---

## 💡 Caractéristiques Techniques

### Robot EVE vs Versions Précédentes

| Caractéristique | robot_smile.py | robot_eve.py |
|----------------|----------------|--------------|
| Résolution | 512x256 | 800x600 |
| FPS | 30 | 60 |
| Émotions | 4 | 7+ |
| Animations spéciales | Non | Oui (larmes, rigolade) |
| Qualité d'affichage | Standard | Haute (smoothscale) |
| Style | Cozmo | EVE (Disney/Pixar) |

### Transitions Fluides

- **60 FPS** : Animation ultra-fluide
- **smoothscale** : Interpolation de haute qualité
- **Animations progressives** : Changements d'état en douceur
- **Physique réaliste** : Larmes avec accélération

---

## 🎓 Exemples de Code

### Créer une Séquence d'Émotions

```python
import time
from roboeyes_pygame import *

# Séquence émotionnelle
emotions_sequence = [
    (HAPPY, 2),      # Sourire pendant 2 secondes
    (LAUGHING, 3),   # Rigolade pendant 3 secondes
    (SAD, 2),        # Tristesse pendant 2 secondes
    (CRYING, 3),     # Pleurs pendant 3 secondes
    (HAPPY, 2),      # Retour au sourire
]

for emotion, duration in emotions_sequence:
    robo.set_mood(emotion)
    time.sleep(duration)
```

### Réagir à des Événements

```python
# Robot qui réagit à la température
temperature = get_temperature()

if temperature > 30:
    robo.set_mood(TIRED)  # Trop chaud
elif temperature < 10:
    robo.set_mood(CRYING)  # Trop froid
else:
    robo.set_mood(HAPPY)  # Parfait !
```

### Animation de Conversation

```python
# Simuler une conversation
robo.set_mood(HAPPY)       # Salutation
time.sleep(2)
robo.set_mood(CURIOUS)     # Écoute
time.sleep(3)
robo.set_mood(LAUGHING)    # Rire à une blague
time.sleep(2)
robo.set_mood(SAD)         # Compassion
time.sleep(2)
robo.set_mood(HAPPY)       # Au revoir joyeux
```

---

## 🎨 Personnalisation Avancée

### Modifier les Animations

#### Vitesse des Larmes
Dans `roboeyes_pygame.py`, ligne ~262 :
```python
if current_time - self.cry_timer > 500:  # Changer 500 pour plus/moins de larmes
```

#### Intensité de la Rigolade
Dans `roboeyes_pygame.py`, ligne ~246-247 :
```python
frequency = 10  # Plus petit = plus rapide
amplitude = 3   # Plus grand = plus de mouvement
```

### Créer Vos Propres Émotions

```python
# Dans roboeyes_pygame.py, ajouter :
EXCITED = 11  # Nouvelle émotion

# Dans set_mood :
elif mood == EXCITED:
    self.excited = True
    self.eyelids_happy_bottom_offset = self.eyelids_happy_bottom_offset_max
    # Ajouter votre animation personnalisée
```

---

## 🌟 Conseils d'Utilisation

### Pour les Démonstrations
1. Commencez avec **HAPPY** (ESPACE)
2. Montrez **LAUGHING** (R) pour l'effet wow
3. Montrez **CRYING** (P) pour les larmes
4. Terminez avec **HAPPY**

### Pour l'Apprentissage
1. Explorez chaque émotion une par une
2. Observez les différences subtiles
3. Essayez de créer des histoires avec les émotions
4. Modifiez le code pour personnaliser

### Pour le Développement
1. Utilisez EVE pour tester rapidement
2. Grand écran = meilleure visibilité
3. 60 FPS = détection facile des bugs d'animation
4. Console affiche les changements d'état

---

## 📊 Comparaison des Programmes

| Programme | Résolution | Émotions | Animations | Usage |
|-----------|-----------|----------|------------|-------|
| robot_smile.py | 512x256 | 4 | Basiques | Apprentissage |
| robot_smile_bleu.py | 512x256 | 4 | Basiques | Yeux bleus |
| robot_eve.py | 800x600 | 7+ | Avancées | **Production** |
| examples/emotions.py | 512x256 | 4 | Auto | Démonstration |
| examples/interactive.py | 512x256 | 4+ | Toutes | Tests |

---

## 🚀 Prochaines Étapes

### Niveau Débutant
- ✅ Tester toutes les émotions
- ✅ Comprendre les différences
- ✅ Créer des séquences simples

### Niveau Intermédiaire
- ✅ Modifier les paramètres d'animation
- ✅ Créer de nouvelles combinaisons
- ✅ Ajouter des sons

### Niveau Avancé
- ✅ Créer de nouvelles émotions
- ✅ Ajouter des capteurs (caméra, micro)
- ✅ Reconnaissance faciale pour copier les émotions
- ✅ Intelligence artificielle pour émotions contextuelles

---

**Amusez-vous avec Robot EVE ! 🤖💙✨**
