"""
Exemple : Contrôle interactif du robot
Utilisez le clavier pour contrôler les yeux
"""

import pygame
import sys
from roboeyes_pygame import RoboEyes, HAPPY, TIRED, ANGRY, DEFAULT, ON, OFF

def main():
    # Initialisation
    pygame.init()
    SCREEN_WIDTH = 128 * 4
    SCREEN_HEIGHT = 64 * 4
    
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("🎮 Robot Interactif")
    
    oled_surface = pygame.Surface((128, 64))
    robo = RoboEyes(oled_surface, 128, 64, frame_rate=30)
    
    clock = pygame.time.Clock()
    
    print("🎮 Mode Interactif")
    print("\n📝 Commandes:")
    print("  1-4 : Changer d'émotion (Normal, Heureux, Fatigué, En colère)")
    print("  O   : Ouvrir les yeux")
    print("  C   : Fermer les yeux")
    print("  B   : Cligner")
    print("  A   : Activer/Désactiver clignement automatique")
    print("  +/- : Agrandir/Réduire les yeux")
    print("  ESC : Quitter")
    
    auto_blink_active = False
    current_size = 28
    
    robo.open_eyes()
    
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                
                # Émotions
                elif event.key == pygame.K_1:
                    robo.set_mood(DEFAULT)
                    print("😐 Normal")
                elif event.key == pygame.K_2:
                    robo.set_mood(HAPPY)
                    print("😊 Heureux")
                elif event.key == pygame.K_3:
                    robo.set_mood(TIRED)
                    print("😴 Fatigué")
                elif event.key == pygame.K_4:
                    robo.set_mood(ANGRY)
                    print("😠 En colère")
                
                # Contrôles des yeux
                elif event.key == pygame.K_o:
                    robo.open_eyes()
                    print("👀 Yeux ouverts")
                elif event.key == pygame.K_c:
                    robo.close_eyes()
                    print("😴 Yeux fermés")
                elif event.key == pygame.K_b:
                    robo.blink()
                    print("😉 Clin d'œil")
                
                # Clignement automatique
                elif event.key == pygame.K_a:
                    auto_blink_active = not auto_blink_active
                    robo.set_auto_blinker(ON if auto_blink_active else OFF, 3, 2)
                    print(f"🔄 Clignement auto: {'ON' if auto_blink_active else 'OFF'}")
                
                # Taille des yeux
                elif event.key == pygame.K_PLUS or event.key == pygame.K_EQUALS:
                    current_size = min(current_size + 4, 50)
                    robo.eyes_width(current_size, current_size)
                    robo.eyes_height(current_size, current_size)
                    print(f"👁️ Taille: {current_size}")
                elif event.key == pygame.K_MINUS:
                    current_size = max(current_size - 4, 16)
                    robo.eyes_width(current_size, current_size)
                    robo.eyes_height(current_size, current_size)
                    print(f"👁️ Taille: {current_size}")
            
            elif event.type == pygame.USEREVENT + 1:
                robo.open_eyes()
        
        # Mise à jour
        robo.update()
        
        # Affichage
        scaled_surface = pygame.transform.scale(oled_surface, (SCREEN_WIDTH, SCREEN_HEIGHT))
        screen.blit(scaled_surface, (0, 0))
        
        # Aide
        font = pygame.font.Font(None, 20)
        help_lines = [
            "1-4: Émotions | O: Ouvrir | C: Fermer | B: Cligner",
            f"A: Auto-blink [{('ON' if auto_blink_active else 'OFF')}] | +/-: Taille [{current_size}]"
        ]
        
        y_offset = SCREEN_HEIGHT - 50
        for line in help_lines:
            text_surface = font.render(line, True, (100, 200, 100))
            text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, y_offset))
            
            bg_rect = text_rect.inflate(10, 5)
            s = pygame.Surface((bg_rect.width, bg_rect.height))
            s.set_alpha(180)
            s.fill((0, 0, 0))
            screen.blit(s, bg_rect)
            screen.blit(text_surface, text_rect)
            y_offset += 25
        
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()
