"""
Robot EVE PRO - Version avec Interface Améliorée
Menu compact avec icônes pour une meilleure expérience utilisateur

Style Disney/Pixar EVE avec interface moderne
"""

import pygame
import sys
from roboeyes_pygame import (RoboEyes, HAPPY, ANGRY, DISGUST, SAD, CRYING, 
                             LAUGHING, TIRED, DEFAULT, ON)

def draw_icon_button(surface, x, y, key, symbol, label="", color=(120, 200, 255)):
    """Dessine un bouton avec symbole ASCII et label"""
    # Fond du bouton
    button_rect = pygame.Rect(x, y, 70, 60)
    pygame.draw.rect(surface, (20, 30, 50), button_rect, border_radius=8)
    pygame.draw.rect(surface, color, button_rect, 2, border_radius=8)
    
    # Symbole ASCII (style classique)
    font_symbol = pygame.font.Font(None, 32)
    symbol_surface = font_symbol.render(symbol, True, (255, 255, 255))
    symbol_rect = symbol_surface.get_rect(center=(x + 35, y + 18))
    surface.blit(symbol_surface, symbol_rect)
    
    # Label (nom de l'émotion)
    if label:
        font_label = pygame.font.Font(None, 16)
        label_surface = font_label.render(label, True, (180, 220, 255))
        label_rect = label_surface.get_rect(center=(x + 35, y + 38))
        surface.blit(label_surface, label_rect)
    
    # Touche (en jaune vif)
    font_key = pygame.font.Font(None, 18)
    key_bg = pygame.Rect(x + 15, y + 48, 40, 10)
    pygame.draw.rect(surface, (50, 50, 0), key_bg, border_radius=3)
    key_surface = font_key.render(key, True, (255, 255, 0))  # Jaune vif
    key_rect = key_surface.get_rect(center=(x + 35, y + 53))
    surface.blit(key_surface, key_rect)

def main():
    """Programme principal - Robot EVE PRO"""
    pygame.init()
    
    # Configuration écran
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600
    
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("🤖 Robot EVE PRO - Interface Améliorée 💙")
    
    # Surface de rendu TRÈS LARGE pour voir les 2 yeux côte à côte
    RENDER_WIDTH = 256  # Taille OLED standard
    RENDER_HEIGHT = 128  # Ratio 2:1 pour voir les 2 yeux
    oled_surface = pygame.Surface((RENDER_WIDTH, RENDER_HEIGHT))
    
    # Créer le robot avec 2 yeux visibles
    robo = RoboEyes(oled_surface, RENDER_WIDTH, RENDER_HEIGHT, frame_rate=60)
    robo.bg_color = (5, 15, 35)
    robo.fg_color = (120, 200, 255)
    # Yeux BEAUCOUP plus petits pour voir les 2
    robo.eyes_width(40, 40)
    robo.eyes_height(40, 40)
    # Plus d'espace entre les yeux
    robo.space_between = 20
    
    # Configuration
    print("🌟 Robot EVE PRO - Interface Améliorée")
    print("=" * 60)
    print("💙 Menu visuel avec icônes")
    print("🎨 Interface moderne et épurée")
    print("✨ 60 FPS - Haute qualité")
    print()
    print("📝 Utilisez les touches indiquées sous chaque icône")
    print("=" * 60)
    
    robo.set_auto_blinker(ON, 4, 2)
    clock = pygame.time.Clock()
    robo.open_eyes()
    
    # État
    current_emotion = DEFAULT
    auto_reset_timer = 0
    auto_reset_delay = 3000  # 3 secondes avant reset
    
    # Mode test automatique
    test_mode = False
    test_emotions = [HAPPY, ANGRY, DISGUST, SAD, CRYING, LAUGHING, DEFAULT]
    test_index = 0
    test_timer = 0
    test_delay = 2000  # 2 secondes par émotion
    emotion_names = {
        DEFAULT: "Normal",
        HAPPY: "Sourire",
        ANGRY: "Colère",
        DISGUST: "Dégoût",
        SAD: "Tristesse",
        CRYING: "Pleurs",
        LAUGHING: "Rigolade",
    }
    
    # Boucle principale
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                
                # Émotions
                elif event.key == pygame.K_l:  # L pour sourire (jaune soleil)
                    robo.set_mood(HAPPY)
                    current_emotion = HAPPY
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_c:
                    robo.set_mood(ANGRY)
                    current_emotion = ANGRY
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_d:
                    robo.set_mood(DISGUST)
                    current_emotion = DISGUST
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_t:
                    robo.set_mood(SAD)
                    current_emotion = SAD
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_p:
                    robo.set_mood(CRYING)
                    current_emotion = CRYING
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_r:
                    robo.set_mood(LAUGHING)
                    current_emotion = LAUGHING
                    auto_reset_timer = pygame.time.get_ticks()
                elif event.key == pygame.K_0:
                    robo.set_mood(DEFAULT)
                    current_emotion = DEFAULT
                    auto_reset_timer = 0
                
                # Mode test (touche M)
                elif event.key == pygame.K_m:
                    test_mode = not test_mode
                    test_index = 0
                    test_timer = pygame.time.get_ticks()
                    print(f"Mode test: {'ON' if test_mode else 'OFF'}")
                
                # Contrôles
                elif event.key == pygame.K_o:
                    robo.open_eyes()
                elif event.key == pygame.K_f:
                    robo.close_eyes()
                elif event.key == pygame.K_b:
                    robo.blink()
            
            elif event.type == pygame.USEREVENT + 1:
                robo.open_eyes()
        
        # Mode test automatique
        if test_mode:
            current_time = pygame.time.get_ticks()
            if current_time - test_timer > test_delay:
                robo.set_mood(test_emotions[test_index])
                current_emotion = test_emotions[test_index]
                print(f"Test: {emotion_names.get(current_emotion, 'Normal')}")
                test_index = (test_index + 1) % len(test_emotions)
                test_timer = current_time
        
        # Reset automatique après 3 secondes
        elif auto_reset_timer > 0:
            if pygame.time.get_ticks() - auto_reset_timer > auto_reset_delay:
                robo.set_mood(DEFAULT)
                current_emotion = DEFAULT
                auto_reset_timer = 0
                print("➡️ Reset automatique")
        
        # Mise à jour
        robo.update()
        
        # Fond dégradé
        for y in range(SCREEN_HEIGHT):
            color_value = int(5 + (y / SCREEN_HEIGHT) * 20)
            pygame.draw.line(screen, (color_value, color_value + 5, color_value + 15), 
                           (0, y), (SCREEN_WIDTH, y))
        
        # Afficher les yeux (étirés pour voir les 2 yeux côte à côte)
        eyes_height = SCREEN_HEIGHT - 140  # Laisser place au menu et titre
        # Étirer horizontalement pour bien voir les 2 yeux
        eyes_width = SCREEN_WIDTH - 100  # Presque toute la largeur
        scaled_surface = pygame.transform.smoothscale(oled_surface, (eyes_width, eyes_height))
        # Centrer
        x_offset = (SCREEN_WIDTH - eyes_width) // 2
        screen.blit(scaled_surface, (x_offset, 70))
        
        # Titre compact en haut
        font_title = pygame.font.Font(None, 40)
        title_text = f"EVE: {emotion_names.get(current_emotion, 'Normal')}"
        text_surface = font_title.render(title_text, True, (120, 200, 255))
        text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, 30))
        
        # Fond titre
        bg_rect = text_rect.inflate(30, 15)
        s = pygame.Surface((bg_rect.width, bg_rect.height))
        s.set_alpha(180)
        s.fill((0, 0, 0))
        screen.blit(s, bg_rect)
        screen.blit(text_surface, text_rect)
        
        # MENU AVEC ICÔNES EN BAS (compact)
        menu_y = SCREEN_HEIGHT - 80
        
        # Fond du menu
        menu_bg = pygame.Surface((SCREEN_WIDTH, 80))
        menu_bg.set_alpha(200)
        menu_bg.fill((0, 0, 0))
        screen.blit(menu_bg, (0, menu_y))
        
        # Séparateur
        pygame.draw.line(screen, (120, 200, 255), (0, menu_y), (SCREEN_WIDTH, menu_y), 2)
        
        # Boutons émotions (ligne 1) avec symboles ASCII classiques
        start_x = 10
        spacing = 80
        y_pos = menu_y + 10
        
        draw_icon_button(screen, start_x + spacing * 0, y_pos, "L", ":-)", "Sourire")
        draw_icon_button(screen, start_x + spacing * 1, y_pos, "C", ">:(", "Colere")
        draw_icon_button(screen, start_x + spacing * 2, y_pos, "D", ":-P", "Degout")
        draw_icon_button(screen, start_x + spacing * 3, y_pos, "T", ":-(", "Triste")
        draw_icon_button(screen, start_x + spacing * 4, y_pos, "P", ":'(", "Pleurs")
        draw_icon_button(screen, start_x + spacing * 5, y_pos, "R", ":-D", "Rire")
        draw_icon_button(screen, start_x + spacing * 6, y_pos, "0", ":-|", "Normal")
        
        # Séparateur vertical
        sep_x = start_x + spacing * 7 - 10
        pygame.draw.line(screen, (120, 200, 255), (sep_x, menu_y + 10), (sep_x, menu_y + 70), 2)
        
        # Boutons contrôles (ligne 1, à droite) avec symboles
        control_x = sep_x + 15
        draw_icon_button(screen, control_x + spacing * 0, y_pos, "O", "O_O", "Ouvrir")
        draw_icon_button(screen, control_x + spacing * 1, y_pos, "F", "-_-", "Fermer")
        draw_icon_button(screen, control_x + spacing * 2, y_pos, "B", ";-)", "Cligner")
        
        # Légende compacte (très petit, en bas)
        font_legend = pygame.font.Font(None, 14)
        test_status = " | M: Mode Test [ON]" if test_mode else " | M: Mode Test"
        legend_text = f"Émotions | Contrôles{test_status} | ESC: Quitter"
        legend_color = (100, 255, 100) if test_mode else (100, 150, 180)
        legend_surface = font_legend.render(legend_text, True, legend_color)
        legend_rect = legend_surface.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT - 8))
        screen.blit(legend_surface, legend_rect)
        
        # Mise à jour
        pygame.display.flip()
        clock.tick(60)
    
    print("\n👋 Au revoir ! (Robot EVE PRO)")
    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
