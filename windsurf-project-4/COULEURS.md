# 🎨 Guide des Couleurs du Robot

## 💙 Yeux Bleus (Nouveau !)

### Lancer le robot avec yeux bleus

```bash
./run_robot.sh bleu
# ou
python3 run_robot.py bleu
```

Le robot aura maintenant des **yeux bleu cyan brillants** ! 💙

---

## 🎨 Personnaliser les Couleurs

### Méthode 1 : Modifier directement dans le code

Ouvrez `roboeyes_pygame.py` et changez les lignes 58-59 :

```python
# Couleurs - YEUX BLEUS ! 💙
self.bg_color = (0, 20, 40)      # Fond (R, G, B)
self.fg_color = (100, 180, 255)  # Yeux (R, G, B)
```

### Méthode 2 : Dans votre programme

```python
from roboeyes_pygame import RoboEyes

robo = RoboEyes(surface, 128, 64)

# Changer les couleurs après création
robo.bg_color = (R, G, B)  # Couleur de fond
robo.fg_color = (R, G, B)  # Couleur des yeux
```

---

## 🌈 Exemples de Couleurs

### Yeux Bleus (actuel)
```python
robo.bg_color = (0, 20, 40)      # Fond bleu foncé
robo.fg_color = (100, 180, 255)  # Yeux bleu cyan
```

### Yeux Verts
```python
robo.bg_color = (0, 20, 0)       # Fond vert foncé
robo.fg_color = (100, 255, 100)  # Yeux vert clair
```

### Yeux Rouges
```python
robo.bg_color = (20, 0, 0)       # Fond rouge foncé
robo.fg_color = (255, 100, 100)  # Yeux rouge clair
```

### Yeux Violets
```python
robo.bg_color = (20, 0, 40)      # Fond violet foncé
robo.fg_color = (200, 100, 255)  # Yeux violet clair
```

### Yeux Jaunes
```python
robo.bg_color = (40, 40, 0)      # Fond jaune foncé
robo.fg_color = (255, 255, 100)  # Yeux jaune clair
```

### Yeux Orange
```python
robo.bg_color = (40, 20, 0)      # Fond orange foncé
robo.fg_color = (255, 180, 100)  # Yeux orange clair
```

### Yeux Blancs (classique)
```python
robo.bg_color = (0, 0, 0)        # Fond noir
robo.fg_color = (255, 255, 255)  # Yeux blancs
```

---

## 🎓 Comprendre les Couleurs RGB

Les couleurs sont définies avec 3 nombres (R, G, B) :
- **R** = Rouge (Red) : 0 à 255
- **G** = Vert (Green) : 0 à 255
- **B** = Bleu (Blue) : 0 à 255

### Exemples :
- `(255, 0, 0)` = Rouge pur
- `(0, 255, 0)` = Vert pur
- `(0, 0, 255)` = Bleu pur
- `(255, 255, 0)` = Jaune (rouge + vert)
- `(255, 0, 255)` = Magenta (rouge + bleu)
- `(0, 255, 255)` = Cyan (vert + bleu)
- `(255, 255, 255)` = Blanc
- `(0, 0, 0)` = Noir

---

## 💡 Exercice : Créer Votre Propre Couleur

1. **Créez un nouveau fichier** `robot_smile_perso.py`

2. **Copiez le code de** `robot_smile_bleu.py`

3. **Changez les couleurs** (lignes 29-30) :
   ```python
   robo.bg_color = (?, ?, ?)  # Votre couleur de fond
   robo.fg_color = (?, ?, ?)  # Votre couleur d'yeux
   ```

4. **Lancez votre robot** :
   ```bash
   python3 robot_smile_perso.py
   ```

---

## 🌟 Idées Créatives

### Robot Arc-en-ciel
Changez la couleur des yeux toutes les secondes !

```python
import time
colors = [
    (255, 100, 100),  # Rouge
    (255, 180, 100),  # Orange
    (255, 255, 100),  # Jaune
    (100, 255, 100),  # Vert
    (100, 180, 255),  # Bleu
    (200, 100, 255),  # Violet
]
color_index = 0
last_change = time.time()

# Dans la boucle principale :
if time.time() - last_change > 1:
    robo.fg_color = colors[color_index]
    color_index = (color_index + 1) % len(colors)
    last_change = time.time()
```

### Robot qui Change selon l'Humeur
```python
if robo.happy:
    robo.fg_color = (255, 255, 100)  # Jaune quand heureux
elif robo.angry:
    robo.fg_color = (255, 100, 100)  # Rouge quand en colère
elif robo.tired:
    robo.fg_color = (150, 150, 200)  # Bleu pâle quand fatigué
```

---

## 🎨 Outil de Sélection de Couleurs

Vous pouvez utiliser des outils en ligne pour choisir vos couleurs :
- Google : "color picker"
- https://htmlcolorcodes.com/fr/
- https://colorpicker.me/

Ces sites vous donnent les valeurs RGB à utiliser !

---

**Amusez-vous à créer votre robot unique ! 🎨🤖**
