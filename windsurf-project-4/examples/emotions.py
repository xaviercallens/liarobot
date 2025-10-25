"""
Exemple : Différentes émotions du robot
Montre comment changer l'humeur des yeux
"""

import pygame
import sys
from roboeyes_pygame import RoboEyes, HAPPY, TIRED, ANGRY, DEFAULT, ON
import time

def main():
    # Initialisation
    pygame.init()
    SCREEN_WIDTH = 128 * 4
    SCREEN_HEIGHT = 64 * 4
    
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("🤖 Émotions du Robot")
    
    oled_surface = pygame.Surface((128, 64))
    robo = RoboEyes(oled_surface, 128, 64, frame_rate=30)
    
    # Activer le clignement
    robo.set_auto_blinker(ON, 3, 2)
    
    clock = pygame.time.Clock()
    
    # Liste des émotions à montrer
    emotions = [
        (DEFAULT, "😐 Normal", 3),
        (HAPPY, "😊 Heureux", 3),
        (TIRED, "😴 Fatigué", 3),
        (ANGRY, "😠 En colère", 3),
        (HAPPY, "😊 Heureux à nouveau", 3),
    ]
    
    current_emotion = 0
    emotion_timer = time.time()
    
    print("🎭 Démonstration des émotions")
    print("Le robot va montrer différentes émotions...")
    
    # Ouvrir les yeux
    robo.open_eyes()
    
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                elif event.key == pygame.K_SPACE:
                    # Passer à l'émotion suivante
                    current_emotion = (current_emotion + 1) % len(emotions)
                    mood, name, duration = emotions[current_emotion]
                    robo.set_mood(mood)
                    print(name)
                    emotion_timer = time.time()
            
            elif event.type == pygame.USEREVENT + 1:
                robo.open_eyes()
        
        # Changer d'émotion automatiquement
        if time.time() - emotion_timer > emotions[current_emotion][2]:
            current_emotion = (current_emotion + 1) % len(emotions)
            mood, name, duration = emotions[current_emotion]
            robo.set_mood(mood)
            print(name)
            emotion_timer = time.time()
        
        # Mise à jour
        robo.update()
        
        # Affichage
        scaled_surface = pygame.transform.scale(oled_surface, (SCREEN_WIDTH, SCREEN_HEIGHT))
        screen.blit(scaled_surface, (0, 0))
        
        # Afficher l'émotion actuelle
        font = pygame.font.Font(None, 36)
        emotion_text = emotions[current_emotion][1]
        text_surface = font.render(emotion_text, True, (100, 200, 255))
        text_rect = text_surface.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT - 30))
        
        bg_rect = text_rect.inflate(20, 10)
        s = pygame.Surface((bg_rect.width, bg_rect.height))
        s.set_alpha(200)
        s.fill((0, 0, 0))
        screen.blit(s, bg_rect)
        screen.blit(text_surface, text_rect)
        
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()
