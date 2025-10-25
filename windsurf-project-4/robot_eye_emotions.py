import pygame
import math
import random
import numpy as np

# Initialize Pygame
pygame.init()

# Screen dimensions
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Robot Eye Display - Emotions")

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (0, 100, 255)
LIGHT_BLUE = (100, 200, 255)
RED = (255, 50, 50)
YELLOW = (255, 255, 100)
GREEN = (100, 255, 100)
PURPLE = (200, 100, 255)
ORANGE = (255, 150, 50)
GRAY = (150, 150, 150)

class Emotion:
    """Classe pour définir les paramètres d'une émotion"""
    def __init__(self, name, pupil_size, eye_openness, eyebrow_angle, 
                 iris_color, pupil_color, blink_rate, movement_speed):
        self.name = name
        self.pupil_size = pupil_size  # Multiplicateur de taille de pupille
        self.eye_openness = eye_openness  # 0.0 à 1.0
        self.eyebrow_angle = eyebrow_angle  # Angle des sourcils en degrés
        self.iris_color = iris_color
        self.pupil_color = pupil_color
        self.blink_rate = blink_rate  # Fréquence de clignement
        self.movement_speed = movement_speed  # Vitesse de mouvement des yeux

# Définition des émotions
EMOTIONS = {
    'neutral': Emotion('Neutre', 1.0, 1.0, 0, LIGHT_BLUE, BLUE, 0.005, 0.1),
    'happy': Emotion('Joyeux', 1.2, 0.85, -15, GREEN, (0, 150, 0), 0.003, 0.15),
    'sad': Emotion('Triste', 0.8, 0.7, 15, GRAY, (100, 100, 100), 0.008, 0.05),
    'angry': Emotion('Colère', 1.5, 1.0, 25, RED, (200, 0, 0), 0.002, 0.2),
    'surprised': Emotion('Surpris', 1.8, 1.2, -25, YELLOW, ORANGE, 0.001, 0.25),
    'fear': Emotion('Peur', 1.6, 1.1, 20, PURPLE, (150, 50, 200), 0.015, 0.3),
    'love': Emotion('Amour', 1.3, 0.9, -10, (255, 150, 200), RED, 0.004, 0.08),
}

class Eye:
    def __init__(self, x, y, size=100, is_left=True):
        self.x = x
        self.y = y
        self.size = size
        self.is_left = is_left
        self.base_pupil_radius = size // 5
        self.target_x = x
        self.target_y = y
        self.current_x = x
        self.current_y = y
        self.blink_state = 0  # 0 = open, 1 = closing, 2 = closed, 3 = opening
        self.blink_progress = 0
        self.blink_speed = 0.1
        self.saccade_timer = 0
        self.saccade_interval = random.randint(30, 120)
        self.current_emotion = EMOTIONS['neutral']
        self.target_emotion = EMOTIONS['neutral']
        self.emotion_transition = 1.0  # 1.0 = transition complète

    def set_emotion(self, emotion_name):
        """Change l'émotion de l'œil"""
        if emotion_name in EMOTIONS:
            self.target_emotion = EMOTIONS[emotion_name]
            self.emotion_transition = 0.0

    def update(self):
        # Transition progressive vers la nouvelle émotion
        if self.emotion_transition < 1.0:
            self.emotion_transition += 0.02
            if self.emotion_transition >= 1.0:
                self.emotion_transition = 1.0
                self.current_emotion = self.target_emotion

        # Update blink animation
        if self.blink_state == 1:  # Closing
            self.blink_progress += self.blink_speed
            if self.blink_progress >= 1:
                self.blink_state = 2  # Closed
                self.blink_progress = 1
        elif self.blink_state == 3:  # Opening
            self.blink_progress -= self.blink_speed
            if self.blink_progress <= 0:
                self.blink_state = 0  # Open
                self.blink_progress = 0

        # Update saccade (random eye movement)
        self.saccade_timer += 1
        if self.saccade_timer >= self.saccade_interval:
            self.saccade_timer = 0
            self.saccade_interval = random.randint(30, 120)
            angle = random.uniform(0, 2 * math.pi)
            distance = random.uniform(0, self.size * 0.3)
            self.target_x = self.x + math.cos(angle) * distance
            self.target_y = self.y + math.sin(angle) * distance

        # Smooth movement towards target (vitesse basée sur l'émotion)
        speed = self.current_emotion.movement_speed
        self.current_x += (self.target_x - self.current_x) * speed
        self.current_y += (self.target_y - self.current_y) * speed

        # Random blinking (fréquence basée sur l'émotion)
        if random.random() < self.current_emotion.blink_rate and self.blink_state == 0:
            self.blink_state = 1

    def draw(self, surface):
        emotion = self.current_emotion
        
        # Dessiner les sourcils
        eyebrow_y = self.current_y - self.size * 0.7
        eyebrow_length = self.size * 0.6
        eyebrow_angle = math.radians(emotion.eyebrow_angle)
        
        if self.is_left:
            eyebrow_start = (self.current_x - eyebrow_length/2, eyebrow_y)
            eyebrow_end = (self.current_x + eyebrow_length/2, 
                          eyebrow_y + eyebrow_length * math.tan(eyebrow_angle))
        else:
            eyebrow_start = (self.current_x - eyebrow_length/2, 
                           eyebrow_y - eyebrow_length * math.tan(eyebrow_angle))
            eyebrow_end = (self.current_x + eyebrow_length/2, eyebrow_y)
        
        pygame.draw.line(surface, WHITE, eyebrow_start, eyebrow_end, 8)

        # Calculer l'ouverture de l'œil basée sur l'émotion
        eye_height = self.size * emotion.eye_openness
        
        # Draw the eye
        if self.blink_state == 2:  # Closed
            pygame.draw.ellipse(surface, WHITE, 
                             (self.current_x - self.size//2, 
                              self.current_y - self.size//6, 
                              self.size, 
                              self.size//3), 0)
        else:
            # Eye white avec hauteur ajustée
            eye_rect = pygame.Rect(
                self.current_x - self.size//2,
                self.current_y - eye_height//2,
                self.size,
                eye_height
            )
            pygame.draw.ellipse(surface, WHITE, eye_rect, 0)
            
            # Iris and pupil
            if self.blink_state == 0 or (self.blink_state == 1 and self.blink_progress < 0.5) or \
               (self.blink_state == 3 and self.blink_progress < 0.5):
                blink_scale = 1.0
                if self.blink_state == 1:
                    blink_scale = 1.0 - self.blink_progress
                elif self.blink_state == 3:
                    blink_scale = 1.0 - self.blink_progress
                
                # Iris
                iris_radius = self.size // 3
                pygame.draw.circle(surface, emotion.iris_color, 
                                (int(self.current_x), int(self.current_y)), 
                                int(iris_radius * blink_scale))
                
                # Pupil (taille basée sur l'émotion)
                mouse_x, mouse_y = pygame.mouse.get_pos()
                dx = mouse_x - self.current_x
                dy = mouse_y - self.current_y
                dist = max(1, math.sqrt(dx*dx + dy*dy))
                
                pupil_radius = int(self.base_pupil_radius * emotion.pupil_size)
                max_offset = (self.size // 2) - pupil_radius - 5
                offset_x = (dx / dist) * min(dist * 0.1, max_offset)
                offset_y = (dy / dist) * min(dist * 0.1, max_offset)
                
                pygame.draw.circle(surface, emotion.pupil_color, 
                                (int(self.current_x + offset_x), 
                                 int(self.current_y + offset_y)), 
                                int(pupil_radius * blink_scale))
                
                # Highlight
                highlight_size = pupil_radius // 2
                pygame.draw.circle(surface, WHITE, 
                                (int(self.current_x + offset_x - pupil_radius//2), 
                                 int(self.current_y + offset_y - pupil_radius//2)), 
                                int(highlight_size * blink_scale))

def draw_instructions(surface):
    """Affiche les instructions à l'écran"""
    font = pygame.font.Font(None, 28)
    instructions = [
        "Contrôles des émotions:",
        "1 - Neutre",
        "2 - Joyeux",
        "3 - Triste",
        "4 - Colère",
        "5 - Surpris",
        "6 - Peur",
        "7 - Amour",
        "ESC - Quitter"
    ]
    
    y_offset = 20
    for i, text in enumerate(instructions):
        color = YELLOW if i == 0 else WHITE
        text_surface = font.render(text, True, color)
        surface.blit(text_surface, (20, y_offset + i * 30))

def draw_current_emotion(surface, emotion_name):
    """Affiche l'émotion actuelle"""
    font = pygame.font.Font(None, 48)
    text = f"Émotion: {EMOTIONS[emotion_name].name}"
    text_surface = font.render(text, True, YELLOW)
    text_rect = text_surface.get_rect(center=(WIDTH // 2, 50))
    surface.blit(text_surface, text_rect)

def main():
    clock = pygame.time.Clock()
    running = True
    
    # Create eyes
    left_eye = Eye(WIDTH // 2 - 120, HEIGHT // 2, 120, is_left=True)
    right_eye = Eye(WIDTH // 2 + 120, HEIGHT // 2, 120, is_left=False)
    
    current_emotion = 'neutral'
    
    # Main game loop
    while running:
        # Handle events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                elif event.key == pygame.K_1:
                    current_emotion = 'neutral'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_2:
                    current_emotion = 'happy'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_3:
                    current_emotion = 'sad'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_4:
                    current_emotion = 'angry'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_5:
                    current_emotion = 'surprised'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_6:
                    current_emotion = 'fear'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
                elif event.key == pygame.K_7:
                    current_emotion = 'love'
                    left_eye.set_emotion(current_emotion)
                    right_eye.set_emotion(current_emotion)
            elif event.type == pygame.MOUSEBUTTONDOWN:
                left_eye.blink_state = 1
                right_eye.blink_state = 1
        
        # Update
        left_eye.update()
        right_eye.update()
        
        # Draw
        screen.fill(BLACK)
        left_eye.draw(screen)
        right_eye.draw(screen)
        draw_instructions(screen)
        draw_current_emotion(screen, current_emotion)
        
        # Update display
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()

if __name__ == "__main__":
    main()
