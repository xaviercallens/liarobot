# 🚀 Guide de Démarrage Rapide

Bienvenue dans le projet Robot Éducatif ! Ce guide vous aidera à démarrer rapidement.

## 📦 Installation (5 minutes)

### Étape 1 : Vérifier Python

Ouvrez un terminal et tapez :
```bash
python --version
```

Vous devez avoir Python 3.7 ou plus récent. Sinon, installez-le depuis [python.org](https://www.python.org/).

### Étape 2 : Installer les dépendances

Dans le dossier du projet, tapez :
```bash
pip install -r requirements.txt
```

### Étape 3 : Lancer votre premier programme !

```bash
python robot_smile.py
```

🎉 **Félicitations !** Vous devriez voir un robot avec un sourire !

## 🎮 Essayer les Exemples

### 1. Sourire Simple (Débutant)
```bash
python robot_smile.py
```
- Appuyez sur **ESPACE** pour faire sourire le robot
- Appuyez sur **O** pour ouvrir les yeux
- Appuyez sur **C** pour fermer les yeux
- Appuyez sur **B** pour cligner

### 2. Démonstration des Émotions
```bash
python examples/emotions.py
```
Le robot montre automatiquement différentes émotions :
- 😐 Normal
- 😊 Heureux
- 😴 Fatigué
- 😠 En colère

### 3. Mode Interactif (Avancé)
```bash
python examples/interactive.py
```
Contrôlez tout avec le clavier :
- **1-4** : Changer d'émotion
- **+/-** : Agrandir/réduire les yeux
- **A** : Activer le clignement automatique

## 🤖 Passer au Robot Réel

Une fois que vous maîtrisez la simulation, vous pouvez créer un vrai robot !

### Matériel nécessaire (environ 20-30€)

1. **Raspberry Pi Pico** (~5€) ou **ESP32** (~8€)
2. **Écran OLED I2C 128x64** (~10€)
3. **Câbles de connexion** (~3€)
4. **Batterie USB** (optionnel, ~10€)

### Installation sur le robot

Consultez le guide détaillé dans `micropython/README.md`

## 📚 Apprendre Étape par Étape

### Pour les Enfants (7-12 ans)

**Semaine 1 : Découverte**
- Jour 1-2 : Lancer les programmes et observer
- Jour 3-4 : Changer les émotions avec les touches
- Jour 5-7 : Expérimenter avec les différents exemples

**Semaine 2 : Personnalisation**
- Modifier la taille des yeux
- Changer la vitesse de clignement
- Créer sa propre séquence d'émotions

**Semaine 3 : Programmation**
- Ouvrir le code et lire les commentaires
- Modifier les couleurs (dans la version Pygame)
- Ajouter de nouvelles touches au clavier

**Semaine 4 : Projet Final**
- Concevoir son propre robot sur papier
- Assembler le matériel
- Programmer le comportement

### Pour les Parents

**Conseils pédagogiques :**

1. **Commencez par jouer** : Laissez votre enfant explorer les programmes
2. **Posez des questions** : "Que se passe-t-il quand tu appuies sur cette touche ?"
3. **Encouragez l'expérimentation** : "Et si on changeait ce nombre ?"
4. **Célébrez les erreurs** : Les bugs sont des opportunités d'apprendre !
5. **Progressez doucement** : Pas besoin de tout comprendre d'un coup

**Concepts abordés :**
- ✅ Variables et constantes
- ✅ Fonctions et paramètres
- ✅ Boucles et conditions
- ✅ Événements et interactions
- ✅ Graphiques et animations
- ✅ Électronique de base (version matérielle)

## 🎯 Défis Amusants

### Défi 1 : Le Robot Endormi
Modifiez `robot_smile.py` pour que le robot :
1. Commence avec les yeux fermés
2. S'ouvre lentement
3. Sourit
4. Se rendort après 10 secondes

### Défi 2 : Le Robot Musicien
Ajoutez des sons quand le robot change d'émotion !
(Indice : utilisez `pygame.mixer`)

### Défi 3 : Le Robot Qui Suit la Souris
Faites en sorte que les yeux suivent le curseur de la souris
(Indice : regardez `robot_eye.py` pour inspiration)

### Défi 4 : Le Robot Parlant
Connectez un capteur de son et faites réagir le robot aux bruits !

## 🆘 Problèmes Courants

### "ModuleNotFoundError: No module named 'pygame'"
**Solution :** Installez pygame avec `pip install pygame`

### "Permission denied"
**Solution :** Sur Linux/Mac, utilisez `python3` au lieu de `python`

### L'écran est tout noir
**Solution :** Vérifiez que vous avez bien appuyé sur 'O' pour ouvrir les yeux

### Le programme ne répond pas
**Solution :** Appuyez sur ESC ou fermez la fenêtre

## 📖 Ressources Supplémentaires

- [Tutoriel Pygame pour débutants](https://www.pygame.org/docs/)
- [MicroPython Documentation](https://docs.micropython.org/)
- [Projet original RoboEyes](https://github.com/mchobby/micropython-roboeyes)

## 💡 Idées de Projets

1. **Robot de bureau** : Réagit quand vous vous approchez
2. **Réveil mignon** : Affiche l'heure avec des expressions
3. **Compagnon d'étude** : Encourage pendant les devoirs
4. **Détecteur d'humeur** : Change d'expression selon la météo
5. **Robot messager** : Affiche des notifications

## 🎓 Aller Plus Loin

Quand vous serez à l'aise :
- Ajoutez des capteurs (distance, température, lumière)
- Créez une interface web pour contrôler le robot
- Faites communiquer plusieurs robots ensemble
- Ajoutez de la reconnaissance vocale
- Créez un jeu interactif avec le robot

## 🤝 Partager Vos Créations

N'hésitez pas à :
- Prendre des photos/vidéos de votre robot
- Partager vos modifications du code
- Inventer de nouvelles émotions
- Créer des tutoriels pour d'autres enfants

---

**Amusez-vous bien et bon apprentissage ! 🚀🤖**

*Questions ? Consultez le README.md ou les commentaires dans le code !*
