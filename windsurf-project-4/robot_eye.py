import pygame
import sys
import math
import numpy as np

class RobotEye:
    def __init__(self, x, y, radius=100, eye_color=(255, 255, 255), pupil_color=(0, 0, 0)):
        self.x = x
        self.y = y
        self.radius = radius
        self.eye_color = eye_color
        self.pupil_color = pupil_color
        self.pupil_radius = radius // 3
        self.pupil_x = x
        self.pupil_y = y
        self.pupil_distance = radius - self.pupil_radius - 5  # Keep pupil within eye

    def update(self, target_x, target_y):
        # Calculate direction to target
        dx = target_x - self.x
        dy = target_y - self.y
        distance = max(1, math.sqrt(dx*dx + dy*dy))
        
        # Normalize and scale by max pupil distance
        scale = min(1.0, self.pupil_distance / distance)
        self.pupil_x = self.x + dx * scale
        self.pupil_y = self.y + dy * scale

    def draw(self, surface):
        # Draw eye (white part)
        pygame.draw.circle(surface, self.eye_color, (int(self.x), int(self.y)), self.radius)
        
        # Draw outer circle (eyelid)
        pygame.draw.circle(surface, (100, 100, 100), (int(self.x), int(self.y)), self.radius, 2)
        
        # Draw pupil
        pygame.draw.circle(surface, self.pupil_color, (int(self.pupil_x), int(self.pupil_y)), self.pupil_radius)
        
        # Draw highlight on pupil
        highlight_radius = self.pupil_radius // 3
        highlight_x = self.pupil_x - self.pupil_radius // 2
        highlight_y = self.pupil_y - self.pupil_radius // 2
        pygame.draw.circle(surface, (255, 255, 255), 
                          (int(highlight_x), int(highlight_y)), 
                          highlight_radius)

def main():
    # Initialize Pygame
    pygame.init()
    
    # Set up display
    width, height = 800, 600
    screen = pygame.display.set_mode((width, height))
    pygame.display.set_caption("Robot Eye Display")
    clock = pygame.time.Clock()
    
    # Create robot eye
    eye = RobotEye(width // 2, height // 2)
    
    # Main game loop
    running = True
    while running:
        # Handle events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
        
        # Get mouse position
        mouse_x, mouse_y = pygame.mouse.get_pos()
        
        # Update eye
        eye.update(mouse_x, mouse_y)
        
        # Draw
        screen.fill((240, 240, 240))  # Light gray background
        eye.draw(screen)
        
        # Update display
        pygame.display.flip()
        clock.tick(60)  # 60 FPS
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()
