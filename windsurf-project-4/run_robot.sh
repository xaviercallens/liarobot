#!/bin/bash

# Script de lancement pour le robot
# Détecte automatiquement la bonne commande Python

echo "🤖 Lancement du Robot..."
echo ""

# Détecter l'environnement virtuel
if [ -f ".venv/bin/python" ]; then
    PYTHON_CMD=".venv/bin/python"
    echo "✅ Utilisation de l'environnement virtuel"
elif command -v python3 &> /dev/null; then
    PYTHON_CMD=python3
    echo "✅ Utilisation de python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD=python
    echo "✅ Utilisation de python"
else
    echo "❌ Python n'est pas installé !"
    exit 1
fi

echo ""

# Vérifier quel programme lancer
if [ "$1" == "smile" ] || [ -z "$1" ]; then
    echo "🎯 Lancement de robot_smile.py (programme principal)"
    $PYTHON_CMD robot_smile.py
elif [ "$1" == "bleu" ] || [ "$1" == "blue" ]; then
    echo "💙 Lancement de robot_smile_bleu.py (YEUX BLEUS!)"
    $PYTHON_CMD robot_smile_bleu.py
elif [ "$1" == "eve" ]; then
    echo "🌟 Lancement de robot_eve.py (VERSION PREMIUM - TOUTES LES ÉMOTIONS!)"
    $PYTHON_CMD robot_eve.py
elif [ "$1" == "eve-pro" ] || [ "$1" == "pro" ]; then
    echo "✨ Lancement de robot_eve_pro.py (INTERFACE AMÉLIORÉE AVEC ICÔNES!)"
    $PYTHON_CMD robot_eve_pro.py
elif [ "$1" == "emotions" ]; then
    echo "🎭 Lancement de examples/emotions.py"
    $PYTHON_CMD examples/emotions.py
elif [ "$1" == "interactive" ]; then
    echo "🎮 Lancement de examples/interactive.py"
    $PYTHON_CMD examples/interactive.py
elif [ "$1" == "eye" ]; then
    echo "👁️ Lancement de robot_eye.py"
    $PYTHON_CMD robot_eye.py
else
    echo "❌ Programme inconnu: $1"
    echo ""
    echo "Usage: ./run_robot.sh [programme]"
    echo ""
    echo "Programmes disponibles:"
    echo "  smile       - Programme principal avec sourire Cozmo (défaut)"
    echo "  bleu/blue   - 💙 Robot avec YEUX BLEUS 💙"
    echo "  eve         - 🌟 VERSION PREMIUM - Toutes les émotions (800x600)"
    echo "  eve-pro/pro - ✨ INTERFACE AMÉLIORÉE avec menu icônes (RECOMMANDÉ)"
    echo "  emotions    - Démonstration des émotions"
    echo "  interactive - Contrôle interactif complet"
    echo "  eye         - Robot eye simple"
    exit 1
fi
