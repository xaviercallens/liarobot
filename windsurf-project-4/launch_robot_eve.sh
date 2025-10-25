#!/bin/bash

echo "🤖 Lancement du Robot EVE (Version Premium)"
echo "============================================"
echo ""
echo "Émotions disponibles:"
echo "  ESPACE - 😊 Sourire"
echo "  C - 😠 Colère"
echo "  D - 🤢 Dégoût"
echo "  T - 😢 Triste"
echo "  P - 😭 Pleurs (avec larmes)"
echo "  R - 😂 Rire"
echo "  0 - 😐 Normal"
echo ""
echo "Contrôles:"
echo "  O - Ouvrir les yeux"
echo "  F - Fermer les yeux"
echo "  B - Cligner"
echo "  A - Toggle auto-blink"
echo "  ESC - Quitter"
echo ""

# Vérifier si l'environnement virtuel existe
if [ ! -d "venv" ]; then
    echo "❌ Environnement virtuel non trouvé!"
    echo "Veuillez d'abord exécuter: ./install_dependencies.sh"
    exit 1
fi

# Lancer le robot
./venv/bin/python robot_eve.py
