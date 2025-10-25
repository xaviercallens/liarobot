#!/bin/bash

echo "🤖 Lancement du Robot Eye avec Émotions"
echo "========================================"
echo ""
echo "Contrôles:"
echo "  1 - 😐 Neutre"
echo "  2 - 😊 Joyeux"
echo "  3 - 😢 Triste"
echo "  4 - 😠 Colère"
echo "  5 - 😲 Surpris"
echo "  6 - 😨 Peur"
echo "  7 - 😍 Amour"
echo "  ESC - Quitter"
echo ""
echo "Les yeux suivent votre souris!"
echo ""

# Vérifier si l'environnement virtuel existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé!"
    echo "Veuillez d'abord exécuter: ./install_dependencies.sh"
    exit 1
fi

# Lancer le robot
./venv/bin/python robot_eye_emotions.py
