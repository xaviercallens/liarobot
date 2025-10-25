#!/bin/bash

echo "🤖 Lancement du Robot Eye Display (Version de base)"
echo "===================================================="
echo ""
echo "Robot avec yeux qui suivent la souris"
echo ""
echo "Contrôles:"
echo "  Souris - Les yeux suivent le curseur"
echo "  Clic - Faire cligner les yeux"
echo "  ESC - Quitter"
echo ""

# Vérifier si l'environnement virtuel existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé!"
    echo "Veuillez d'abord exécuter: ./install_dependencies.sh"
    exit 1
fi

# Lancer le robot
./venv/bin/python robot_eye_display.py
