#!/bin/bash

echo "🤖 Installation des dépendances pour les robots"
echo "================================================"
echo ""

# Vérifier si Python3 est installé
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

echo "✅ Python3 trouvé: $(python3 --version)"
echo ""

# Créer l'environnement virtuel s'il n'existe pas
if [ ! -d "venv" ]; then
    echo "📦 Création de l'environnement virtuel..."
    python3 -m venv venv
    echo "✅ Environnement virtuel créé"
else
    echo "✅ Environnement virtuel déjà existant"
fi

echo ""
echo "📥 Installation des dépendances..."
echo ""

# Activer l'environnement virtuel et installer les dépendances
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt

echo ""
echo "✅ Installation terminée!"
echo ""
echo "🎮 Vous pouvez maintenant lancer les robots avec:"
echo "   ./launch_robot_emotions.sh    - Robot avec émotions (7 émotions)"
echo "   ./launch_robot_eve.sh         - Robot EVE (version premium)"
echo "   ./launch_robot_eve_pro.sh     - Robot EVE Pro (version avancée)"
echo "   ./launch_robot_smile.sh       - Robot sourire (version simple)"
echo ""
