"""
Programme principal - Robot avec sourire style Cozmo
Pour apprendre la programmation avec votre enfant !

Basé sur: https://github.com/mchobby/micropython-roboeyes
"""

import pygame
import sys
from roboeyes_pygame import RoboEyes, HAPPY, ON

def main():
    """Programme principal"""
    # Initialiser Pygame
    pygame.init()
    
    # Configuration de l'écran (comme un écran OLED 128x64)
    SCREEN_WIDTH = 128 * 4  # Agrandi x4 pour mieux voir
    SCREEN_HEIGHT = 64 * 4
    
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("🤖 Robot Sourire - Style Cozmo")
    
    # Créer une surface pour dessiner (taille réelle de l'écran OLED)
    oled_surface = pygame.Surface((128, 64))
    
    # Créer les yeux du robot
    robo = RoboEyes(oled_surface, 128, 64, frame_rate=30)
    
    # Configuration initiale
    print("🤖 Initialisation du robot...")
    print("📝 Instructions:")
    print("   - Appuyez sur ESPACE pour faire sourire le robot")
    print("   - Appuyez sur 'O' pour ouvrir les yeux")
    print("   - Appuyez sur 'C' pour fermer les yeux")
    print("   - Appuyez sur 'B' pour faire cligner les yeux")
    print("   - Appuyez sur ESC pour quitter")
    
    # Activer le clignement automatique (toutes les 3-5 secondes)
    robo.set_auto_blinker(ON, 3, 2)
    
    # Horloge pour contrôler les FPS
    clock = pygame.time.Clock()
    
    # Ouvrir les yeux au démarrage
    robo.open_eyes()
    
    # Variable pour savoir si on sourit
    is_smiling = False
    
    # Boucle principale
    running = True
    while running:
        # Gérer les événements
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                
                elif event.key == pygame.K_SPACE:
                    # Faire sourire le robot (comme Cozmo!)
                    if not is_smiling:
                        print("😊 Le robot sourit !")
                        robo.set_mood(HAPPY)
                        is_smiling = True
                    else:
                        print("😐 Expression normale")
                        robo.set_mood(0)  # DEFAULT
                        is_smiling = False
                
                elif event.key == pygame.K_o:
                    # Ouvrir les yeux
                    print("👀 Ouverture des yeux")
                    robo.open_eyes()
                
                elif event.key == pygame.K_c:
                    # Fermer les yeux
                    print("😴 Fermeture des yeux")
                    robo.close_eyes()
                
                elif event.key == pygame.K_b:
                    # Cligner des yeux
                    print("😉 Clin d'œil")
                    robo.blink()
            
            elif event.type == pygame.USEREVENT + 1:
                # Événement pour rouvrir les yeux après un clignement
                robo.open_eyes()
        
        # Mettre à jour les yeux
        robo.update()
        
        # Agrandir la surface OLED pour l'affichage
        scaled_surface = pygame.transform.scale(oled_surface, (SCREEN_WIDTH, SCREEN_HEIGHT))
        screen.blit(scaled_surface, (0, 0))
        
        # Afficher le texte d'aide
        font = pygame.font.Font(None, 24)
        help_text = "ESPACE: Sourire | O: Ouvrir | C: Fermer | B: Cligner | ESC: Quitter"
        text_surface = font.render(help_text, True, (100, 200, 100))
        text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT - 20))
        
        # Fond semi-transparent pour le texte
        bg_rect = text_rect.inflate(20, 10)
        s = pygame.Surface((bg_rect.width, bg_rect.height))
        s.set_alpha(200)
        s.fill((0, 0, 0))
        screen.blit(s, bg_rect)
        screen.blit(text_surface, text_rect)
        
        # Mettre à jour l'affichage
        pygame.display.flip()
        
        # Limiter à 60 FPS
        clock.tick(60)
    
    # Quitter proprement
    print("👋 Au revoir !")
    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
