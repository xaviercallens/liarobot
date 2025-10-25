#!/usr/bin/env python3
"""
Script de lancement universel pour le robot
Fonctionne sur Linux, Mac et Windows
"""

import sys
import os
import subprocess

def main():
    print("🤖 Lancement du Robot...")
    print()
    
    # Déterminer quel programme lancer
    if len(sys.argv) > 1:
        choice = sys.argv[1].lower()
    else:
        choice = "smile"
    
    programs = {
        "smile": ("robot_smile.py", "Programme principal avec sourire Cozmo"),
        "bleu": ("robot_smile_bleu.py", "💙 Robot avec YEUX BLEUS 💙"),
        "blue": ("robot_smile_bleu.py", "💙 Robot avec YEUX BLEUS 💙"),
        "eve": ("robot_eve.py", "🌟 VERSION PREMIUM - Toutes les émotions (800x600)"),
        "eve-pro": ("robot_eve_pro.py", "✨ INTERFACE AMÉLIORÉE avec menu icônes (RECOMMANDÉ)"),
        "pro": ("robot_eve_pro.py", "✨ INTERFACE AMÉLIORÉE avec menu icônes (RECOMMANDÉ)"),
        "emotions": ("examples/emotions.py", "Démonstration des émotions"),
        "interactive": ("examples/interactive.py", "Contrôle interactif complet"),
        "eye": ("robot_eye.py", "Robot eye simple"),
    }
    
    if choice not in programs:
        print(f"❌ Programme inconnu: {choice}")
        print()
        print("Usage: python3 run_robot.py [programme]")
        print()
        print("Programmes disponibles:")
        for key, (file, desc) in programs.items():
            print(f"  {key:12} - {desc}")
        sys.exit(1)
    
    program_file, description = programs[choice]
    
    if not os.path.exists(program_file):
        print(f"❌ Fichier introuvable: {program_file}")
        sys.exit(1)
    
    print(f"🎯 Lancement de {program_file}")
    print(f"   {description}")
    print()
    
    # Lancer le programme
    try:
        subprocess.run([sys.executable, program_file])
    except KeyboardInterrupt:
        print("\n👋 Arrêt du robot")
    except Exception as e:
        print(f"❌ Erreur: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
