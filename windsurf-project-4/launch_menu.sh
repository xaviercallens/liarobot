#!/bin/bash

clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║              🤖 MENU DE LANCEMENT DES ROBOTS 🤖              ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Choisissez un robot à lancer:"
echo ""
echo "  1) 🎭 Robot Eye Emotions    - 7 émotions contrôlées par touches"
echo "  2) 🌟 Robot EVE             - Version premium avec animations"
echo "  3) ⭐ Robot EVE PRO         - Version avancée avec menu graphique"
echo "  4) 😊 Robot Smile           - Version simple avec sourire"
echo "  5) 👁️  Robot Eye Display    - Yeux qui suivent la souris"
echo ""
echo "  i) 📦 Installer les dépendances"
echo "  q) ❌ Quitter"
echo ""
echo -n "Votre choix: "
read choice

case $choice in
    1)
        echo ""
        ./launch_robot_emotions.sh
        ;;
    2)
        echo ""
        ./launch_robot_eve.sh
        ;;
    3)
        echo ""
        ./launch_robot_eve_pro.sh
        ;;
    4)
        echo ""
        ./launch_robot_smile.sh
        ;;
    5)
        echo ""
        ./launch_robot_display.sh
        ;;
    i|I)
        echo ""
        ./install_dependencies.sh
        ;;
    q|Q)
        echo ""
        echo "👋 Au revoir!"
        exit 0
        ;;
    *)
        echo ""
        echo "❌ Choix invalide!"
        exit 1
        ;;
esac
