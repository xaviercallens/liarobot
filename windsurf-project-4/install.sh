#!/bin/bash

# Script d'installation pour le projet Robot Éducatif
# Pour Linux/Mac

echo "🤖 Installation du Projet Robot Éducatif"
echo "========================================"
echo ""

# Vérifier Python
echo "📋 Vérification de Python..."
if command -v python3 &> /dev/null; then
    PYTHON_CMD=python3
    echo "✅ Python3 trouvé: $(python3 --version)"
elif command -v python &> /dev/null; then
    PYTHON_CMD=python
    echo "✅ Python trouvé: $(python --version)"
else
    echo "❌ Python n'est pas installé !"
    echo "   Installez Python depuis https://www.python.org/"
    exit 1
fi

# Vérifier pip
echo ""
echo "📋 Vérification de pip..."
if command -v pip3 &> /dev/null; then
    PIP_CMD=pip3
    echo "✅ pip3 trouvé"
elif command -v pip &> /dev/null; then
    PIP_CMD=pip
    echo "✅ pip trouvé"
else
    echo "❌ pip n'est pas installé !"
    exit 1
fi

# Installer les dépendances
echo ""
echo "📦 Installation des dépendances..."
$PIP_CMD install -r requirements.txt

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Installation réussie !"
    echo ""
    echo "🚀 Pour démarrer, lancez :"
    echo "   $PYTHON_CMD robot_smile.py"
    echo ""
    echo "📚 Consultez GUIDE_DEMARRAGE.md pour plus d'informations"
else
    echo ""
    echo "❌ Erreur lors de l'installation"
    echo "   Essayez manuellement : $PIP_CMD install pygame numpy"
fi
