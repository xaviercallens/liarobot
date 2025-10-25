#!/bin/bash

echo "🤖 Lancement du Robot Sourire (Version Simple)"
echo "==============================================="
echo ""
echo "Contrôles:"
echo "  ESPACE - Faire sourire"
echo "  O - Ouvrir les yeux"
echo "  C - Fermer les yeux"
echo "  B - Cligner"
echo "  ESC - Quitter"
echo ""

# Vérifier si l'environnement virtuel existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé!"
    echo "Veuillez d'abord exécuter: ./install_dependencies.sh"
    exit 1
fi

# Lancer le robot
./venv/bin/python robot_smile.py
