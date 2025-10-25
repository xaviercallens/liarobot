import pygame
import math
import random
import numpy as np

# Initialize Pygame
pygame.init()

# Screen dimensions
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Robot Eye Display")

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (0, 100, 255)
LIGHT_BLUE = (100, 200, 255)
GRAY = (200, 200, 200)

class Eye:
    def __init__(self, x, y, size=100, eye_color=WHITE, pupil_color=BLUE):
        self.x = x
        self.y = y
        self.size = size
        self.eye_color = eye_color
        self.pupil_color = pupil_color
        self.pupil_radius = size // 5
        self.target_x = x
        self.target_y = y
        self.current_x = x
        self.current_y = y
        self.blink_state = 0  # 0 = open, 1 = closing, 2 = closed, 3 = opening
        self.blink_progress = 0
        self.blink_speed = 0.1
        self.saccade_timer = 0
        self.saccade_interval = random.randint(30, 120)  # frames

    def update(self):
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
            # Random target within a certain range
            angle = random.uniform(0, 2 * math.pi)
            distance = random.uniform(0, self.size * 0.3)
            self.target_x = self.x + math.cos(angle) * distance
            self.target_y = self.y + math.sin(angle) * distance

        # Smooth movement towards target
        self.current_x += (self.target_x - self.current_x) * 0.1
        self.current_y += (self.target_y - self.current_y) * 0.1

        # Random blinking
        if random.random() < 0.005 and self.blink_state == 0:  # 0.5% chance per frame
            self.blink_state = 1  # Start closing

    def draw(self, surface):
        # Draw the eye
        if self.blink_state == 2:  # Closed
            pygame.draw.ellipse(surface, self.eye_color, 
                             (self.current_x - self.size//2, 
                              self.current_y - self.size//6, 
                              self.size, 
                              self.size//3), 0)
        else:
            # Eye white
            pygame.draw.ellipse(surface, self.eye_color, 
                             (self.current_x - self.size//2, 
                              self.current_y - self.size//2, 
                              self.size, self.size), 0)
            
            # Iris and pupil (only if not blinking)
            if self.blink_state == 0 or (self.blink_state == 1 and self.blink_progress < 0.5) or \
               (self.blink_state == 3 and self.blink_progress < 0.5):
                # Calculate pupil position with blink effect
                blink_scale = 1.0
                if self.blink_state == 1:  # Closing
                    blink_scale = 1.0 - self.blink_progress
                elif self.blink_state == 3:  # Opening
                    blink_scale = 1.0 - self.blink_progress
                
                # Iris
                iris_radius = self.size // 3
                pygame.draw.circle(surface, LIGHT_BLUE, 
                                (int(self.current_x), int(self.current_y)), 
                                int(iris_radius * blink_scale))
                
                # Pupil
                # Calculate direction to look at mouse
                mouse_x, mouse_y = pygame.mouse.get_pos()
                dx = mouse_x - self.current_x
                dy = mouse_y - self.current_y
                dist = max(1, math.sqrt(dx*dx + dy*dy))
                max_offset = (self.size // 2) - self.pupil_radius - 5
                offset_x = (dx / dist) * min(dist * 0.1, max_offset)
                offset_y = (dy / dist) * min(dist * 0.1, max_offset)
                
                pygame.draw.circle(surface, self.pupil_color, 
                                (int(self.current_x + offset_x), 
                                 int(self.current_y + offset_y)), 
                                int(self.pupil_radius * blink_scale))
                
                # Highlight
                highlight_size = self.pupil_radius // 2
                pygame.draw.circle(surface, WHITE, 
                                (int(self.current_x + offset_x - self.pupil_radius//2), 
                                 int(self.current_y + offset_y - self.pupil_radius//2)), 
                                int(highlight_size * blink_scale))

def main():
    clock = pygame.time.Clock()
    running = True
    
    # Create eyes
    left_eye = Eye(WIDTH // 2 - 100, HEIGHT // 2, 120)
    right_eye = Eye(WIDTH // 2 + 100, HEIGHT // 2, 120)
    
    # Main game loop
    while running:
        # Handle events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                # Make the eyes blink when clicking
                left_eye.blink_state = 1
                right_eye.blink_state = 1
        
        # Update
        left_eye.update()
        right_eye.update()
        
        # Draw
        screen.fill(BLACK)
        left_eye.draw(screen)
        right_eye.draw(screen)
        
        # Update display
        pygame.display.flip()
        clock.tick(60)
    
    pygame.quit()

if __name__ == "__main__":
    main()
