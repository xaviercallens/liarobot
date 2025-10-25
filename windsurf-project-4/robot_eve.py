"""
Robot EVE - Version Premium avec Toutes les Émotions
Style Disney/Pixar avec transitions fluides et haute qualité

Émotions disponibles :
- ESPACE : Sourire (HAPPY)
- C : Colère (ANGRY) 😠
- D : Dégoût (DISGUST) 🤢
- T : Tristesse (SAD) 😢
- P : Pleurs (CRYING) 😭
- R : Rigolade (LAUGHING) 😂
- O : Ouvrir les yeux
- F : Fermer les yeux
- B : Cligner
"""

import pygame
import sys
from roboeyes_pygame import (RoboEyes, HAPPY, ANGRY, DISGUST, SAD, CRYING, 
                             LAUGHING, TIRED, DEFAULT, ON)

def main():
    """Programme principal - Robot EVE"""
    # Initialiser Pygame
    pygame.init()
    
    # ÉCRAN AGRANDI pour tests sur terminal (style EVE)
    SCREEN_WIDTH = 800   # Grand écran
    SCREEN_HEIGHT = 600
    
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("🤖 Robot EVE - Toutes les Émotions 💙")
    
    # Surface de rendu haute qualité
    RENDER_WIDTH = 400
    RENDER_HEIGHT = 300
    oled_surface = pygame.Surface((RENDER_WIDTH, RENDER_HEIGHT))
    
    # Créer les yeux du robot avec haute qualité
    robo = RoboEyes(oled_surface, RENDER_WIDTH, RENDER_HEIGHT, frame_rate=60)
    
    # Couleurs style EVE (bleu brillant)
    robo.bg_color = (5, 15, 35)      # Fond bleu spatial
    robo.fg_color = (120, 200, 255)  # Yeux bleu brillant
    
    # Yeux plus grands pour meilleure visibilité
    robo.eyes_width(80, 80)
    robo.eyes_height(80, 80)
    
    # Configuration
    print("🤖 Robot EVE - Version Premium")
    print("=" * 60)
    print("💙 Écran agrandi pour tests (800x600)")
    print("🎨 Transitions fluides à 60 FPS")
    print("✨ Qualité haute définition")
    print()
    print("📝 CONTRÔLES DES ÉMOTIONS :")
    print("   ESPACE  → 😊 Sourire (HAPPY)")
    print("   C       → 😠 Colère (ANGRY)")
    print("   D       → 🤢 Dégoût (DISGUST)")
    print("   T       → 😢 Tristesse (SAD)")
    print("   P       → 😭 Pleurs (CRYING)")
    print("   R       → 😂 Rigolade (LAUGHING)")
    print()
    print("📝 CONTRÔLES DES YEUX :")
    print("   O       → 👀 Ouvrir les yeux")
    print("   F       → 😴 Fermer les yeux")
    print("   B       → 😉 Cligner")
    print("   A       → 🔄 Toggle clignement auto")
    print()
    print("   ESC     → Quitter")
    print("=" * 60)
    
    # Activer le clignement automatique
    robo.set_auto_blinker(ON, 4, 2)
    auto_blink = True
    
    # Horloge pour contrôler les FPS
    clock = pygame.time.Clock()
    
    # Ouvrir les yeux au démarrage
    robo.open_eyes()
    
    # État actuel
    current_emotion = "DEFAULT"
    emotion_names = {
        DEFAULT: "😐 Normal",
        HAPPY: "😊 Sourire",
        ANGRY: "😠 Colère",
        DISGUST: "🤢 Dégoût",
        SAD: "😢 Tristesse",
        CRYING: "😭 Pleurs",
        LAUGHING: "😂 Rigolade",
        TIRED: "😴 Fatigué"
    }
    
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
                
                # ÉMOTIONS
                elif event.key == pygame.K_SPACE:
                    robo.set_mood(HAPPY)
                    current_emotion = "HAPPY"
                    print(f"💙 {emotion_names[HAPPY]}")
                
                elif event.key == pygame.K_c:
                    robo.set_mood(ANGRY)
                    current_emotion = "ANGRY"
                    print(f"💙 {emotion_names[ANGRY]}")
                
                elif event.key == pygame.K_d:
                    robo.set_mood(DISGUST)
                    current_emotion = "DISGUST"
                    print(f"💙 {emotion_names[DISGUST]}")
                
                elif event.key == pygame.K_t:
                    robo.set_mood(SAD)
                    current_emotion = "SAD"
                    print(f"💙 {emotion_names[SAD]}")
                
                elif event.key == pygame.K_p:
                    robo.set_mood(CRYING)
                    current_emotion = "CRYING"
                    print(f"💙 {emotion_names[CRYING]} (avec larmes!)")
                
                elif event.key == pygame.K_r:
                    robo.set_mood(LAUGHING)
                    current_emotion = "LAUGHING"
                    print(f"💙 {emotion_names[LAUGHING]} (yeux qui tremblent!)")
                
                # CONTRÔLES DES YEUX
                elif event.key == pygame.K_o:
                    robo.open_eyes()
                    print("👀 Yeux ouverts")
                
                elif event.key == pygame.K_f:
                    robo.close_eyes()
                    print("😴 Yeux fermés")
                
                elif event.key == pygame.K_b:
                    robo.blink()
                    print("😉 Clin d'œil")
                
                elif event.key == pygame.K_a:
                    auto_blink = not auto_blink
                    robo.set_auto_blinker(ON if auto_blink else 0, 4, 2)
                    print(f"🔄 Clignement auto: {'ON' if auto_blink else 'OFF'}")
                
                elif event.key == pygame.K_0:
                    robo.set_mood(DEFAULT)
                    current_emotion = "DEFAULT"
                    print(f"💙 {emotion_names[DEFAULT]}")
            
            elif event.type == pygame.USEREVENT + 1:
                robo.open_eyes()
        
        # Mettre à jour les yeux
        robo.update()
        
        # Agrandir avec interpolation de haute qualité
        scaled_surface = pygame.transform.smoothscale(oled_surface, (SCREEN_WIDTH, SCREEN_HEIGHT))
        screen.blit(scaled_surface, (0, 0))
        
        # Afficher l'émotion actuelle en haut
        font_title = pygame.font.Font(None, 48)
        emotion_text = emotion_names.get(robo._mood, "😐 Normal")
        text_surface = font_title.render(f"EVE: {emotion_text}", True, (120, 200, 255))
        text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, 40))
        
        # Fond semi-transparent
        bg_rect = text_rect.inflate(40, 20)
        s = pygame.Surface((bg_rect.width, bg_rect.height))
        s.set_alpha(220)
        s.fill((0, 0, 0))
        screen.blit(s, bg_rect)
        screen.blit(text_surface, text_rect)
        
        # Afficher les contrôles en bas
        font_help = pygame.font.Font(None, 20)
        help_lines = [
            "ESPACE:😊 C:😠 D:🤢 T:😢 P:😭 R:😂 | O:Ouvrir F:Fermer B:Cligner A:Auto | ESC:Quitter"
        ]
        
        y_offset = SCREEN_HEIGHT - 30
        for line in help_lines:
            text_surface = font_help.render(line, True, (100, 180, 255))
            text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, y_offset))
            
            bg_rect = text_rect.inflate(20, 10)
            s = pygame.Surface((bg_rect.width, bg_rect.height))
            s.set_alpha(200)
            s.fill((0, 0, 0))
            screen.blit(s, bg_rect)
            screen.blit(text_surface, text_rect)
            y_offset += 25
        
        # Mettre à jour l'affichage
        pygame.display.flip()
        
        # Limiter à 60 FPS pour des transitions fluides
        clock.tick(60)
    
    # Quitter proprement
    print("\n👋 Au revoir ! (Robot EVE)")
    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
