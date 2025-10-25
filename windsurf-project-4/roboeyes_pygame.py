"""
Bibliothèque RoboEyes adaptée pour Pygame
Basée sur: https://github.com/mchobby/micropython-roboeyes
Simplifiée pour l'apprentissage avec les enfants
"""

import pygame
import math
import time
from random import randint

# Constantes pour les humeurs (moods)
DEFAULT = 0
TIRED = 1
ANGRY = 2
HAPPY = 3
FROZEN = 4
SCARY = 5
CURIOUS = 6
DISGUST = 7  # Dégoût
SAD = 8      # Tristesse
CRYING = 9   # Pleurs
LAUGHING = 10  # Rigolade

# Constantes ON/OFF
ON = 1
OFF = 0

# Positions prédéfinies
N = 1   # nord (haut centre)
NE = 2  # nord-est (haut droite)
E = 3   # est (milieu droite)
SE = 4  # sud-est (bas droite)
S = 5   # sud (bas centre)
SW = 6  # sud-ouest (bas gauche)
W = 7   # ouest (milieu gauche)
NW = 8  # nord-ouest (haut gauche)
CENTER = 0  # centre


class RoboEyes:
    """Classe principale pour dessiner des yeux de robot animés"""
    
    def __init__(self, surface, width, height, frame_rate=30):
        """
        Initialise les yeux du robot
        
        Args:
            surface: Surface Pygame où dessiner
            width: Largeur de l'écran
            height: Hauteur de l'écran
            frame_rate: Images par seconde (FPS)
        """
        self.surface = surface
        self.screen_width = width
        self.screen_height = height
        self.frame_rate = frame_rate
        self.frame_interval = 1000 // frame_rate
        self.fps_timer = 0
        
        # Couleurs - YEUX BLEUS ! 💙
        self.bg_color = (0, 20, 40)  # Bleu très foncé (fond)
        self.fg_color = (100, 180, 255)  # Bleu clair (yeux)
        
        # Humeur actuelle
        self._mood = DEFAULT
        self.tired = False
        self.angry = False
        self.happy = False
        self.disgust = False
        self.sad = False
        self.crying = False
        self.laughing = False
        
        # Animation de rigolade
        self.laugh_shake_offset = 0
        self.laugh_timer = 0
        
        # Animation de pleurs
        self.cry_timer = 0
        self.tears = []  # Liste de larmes
        
        # Animation de colère (yeux rouges qui pulsent)
        self.angry_timer = 0
        self.angry_pulse = 0
        self.angry_color = (255, 50, 50)  # Rouge colère
        
        # Animation de dégoût (yeux verts)
        self.disgust_color = (100, 255, 100)  # Vert dégoût
        
        # Animation de sourire (yeux jaunes comme soleils)
        self.happy_color = (255, 255, 100)  # Jaune soleil
        self.sun_rays = []  # Rayons du soleil
        
        # Géométrie des yeux
        self.space_between = 10
        
        # Œil gauche - dimensions
        self.eye_l_width_default = 36
        self.eye_l_height_default = 36
        self.eye_l_width = self.eye_l_width_default
        self.eye_l_height = 1  # Commence fermé
        self.eye_l_height_next = self.eye_l_height_default
        self.eye_l_radius = 8
        
        # Œil droit - dimensions
        self.eye_r_width_default = 36
        self.eye_r_height_default = 36
        self.eye_r_width = self.eye_r_width_default
        self.eye_r_height = 1  # Commence fermé
        self.eye_r_height_next = self.eye_r_height_default
        self.eye_r_radius = 8
        
        # Positions des yeux
        self.eye_l_x = int((self.screen_width - (self.eye_l_width + self.space_between + self.eye_r_width)) / 2)
        self.eye_l_y = int((self.screen_height - self.eye_l_height_default) / 2)
        self.eye_r_x = self.eye_l_x + self.eye_l_width + self.space_between
        self.eye_r_y = self.eye_l_y
        
        # Paupières
        self.eyelids_tired_height = 0
        self.eyelids_angry_height = 0
        self.eyelids_happy_bottom_offset = 0
        self.eyelids_happy_bottom_offset_max = int(self.eye_l_height_default / 2) + 3
        
        # Clignement automatique
        self.auto_blinker = False
        self.blink_interval = 3
        self.blink_interval_variation = 2
        self.blink_timer = 0
        
        # Mode idle (yeux qui bougent)
        self.idle = False
        self.idle_interval = 2
        self.idle_interval_variation = 3
        self.idle_timer = 0
        
        # Position actuelle
        self._position = CENTER
        
    def update(self):
        """Met à jour et dessine les yeux"""
        current_time = pygame.time.get_ticks()
        
        # Limiter le taux de rafraîchissement
        if current_time - self.fps_timer >= self.frame_interval:
            # Clignement automatique
            if self.auto_blinker and not self.laughing:
                self._handle_auto_blink(current_time)
            
            # Mode idle
            if self.idle:
                self._handle_idle(current_time)
            
            # Animation de rigolade
            if self.laughing:
                self._handle_laughing(current_time)
            
            # Animation de pleurs
            if self.crying:
                self._handle_crying(current_time)
            
            # Animation de colère
            if self.angry:
                self._handle_angry(current_time)
            
            # Animer l'ouverture/fermeture des yeux
            self._animate_eyes()
            
            # Dessiner
            self.draw_eyes()
            self.fps_timer = current_time
    
    def draw_eyes(self):
        """Dessine les yeux sur la surface"""
        # Effacer l'écran
        self.surface.fill(self.bg_color)
        
        # Calculer l'offset de rigolade
        shake_x = 0
        shake_y = 0
        if self.laughing:
            shake_x = self.laugh_shake_offset
            shake_y = abs(self.laugh_shake_offset) // 2
        
        # Calculer la taille pour la colère (pulse)
        width_l = self.eye_l_width
        height_l = self.eye_l_height
        width_r = self.eye_r_width
        height_r = self.eye_r_height
        
        if self.angry:
            # Effet de pulse (grand/petit en croix)
            width_l += self.angry_pulse
            height_l -= self.angry_pulse // 2
            width_r += self.angry_pulse
            height_r -= self.angry_pulse // 2
        
        # Dessiner l'œil gauche
        self._draw_eye(self.eye_l_x + shake_x, self.eye_l_y + shake_y, width_l, 
                      height_l, self.eye_l_radius, "left")
        
        # Dessiner l'œil droit
        self._draw_eye(self.eye_r_x + shake_x, self.eye_r_y + shake_y, width_r, 
                      height_r, self.eye_r_radius, "right")
        
        # Dessiner les larmes si en pleurs
        if self.crying:
            for tear in self.tears:
                pygame.draw.circle(self.surface, self.fg_color, 
                                 (int(tear['x']), int(tear['y'])), tear['size'])
        
        # Dessiner les rayons de soleil si sourire (yeux jaunes)
        if self.happy:
            self._draw_sun_rays(self.eye_l_x + width_l // 2, self.eye_l_y + height_l // 2, width_l)
            self._draw_sun_rays(self.eye_r_x + width_r // 2, self.eye_r_y + height_r // 2, width_r)
        
        # Dessiner les arcs de dégoût (vers le bas)
        if self.disgust:
            self._draw_disgust_arcs(self.eye_l_x, self.eye_l_y, width_l, height_l)
            self._draw_disgust_arcs(self.eye_r_x, self.eye_r_y, width_r, height_r)
    
    def _draw_eye(self, x, y, width, height, radius, side):
        """Dessine un œil individuel avec des coins arrondis"""
        if height < 2:
            return
        
        # Choisir la couleur selon l'émotion
        if self.angry:
            eye_color = self.angry_color  # Rouge
        elif self.disgust:
            eye_color = self.disgust_color  # Vert
        elif self.happy:
            eye_color = self.happy_color  # Jaune soleil
        else:
            eye_color = self.fg_color  # Bleu normal
        
        # Rectangle principal de l'œil
        rect = pygame.Rect(x, y, width, height)
        pygame.draw.rect(self.surface, eye_color, rect, border_radius=radius)
        
        # Paupière supérieure (fatigue ou colère)
        if self.eyelids_tired_height > 0:
            eyelid_rect = pygame.Rect(x, y, width, self.eyelids_tired_height)
            pygame.draw.rect(self.surface, self.bg_color, eyelid_rect)
        
        if self.eyelids_angry_height > 0:
            # Paupière en angle pour la colère
            points = [
                (x, y + self.eyelids_angry_height),
                (x + width, y),
                (x + width, y + self.eyelids_angry_height)
            ]
            pygame.draw.polygon(self.surface, self.bg_color, points)
        
        # Paupière inférieure (sourire/bonheur)
        if self.eyelids_happy_bottom_offset > 0:
            bottom_y = y + height - self.eyelids_happy_bottom_offset
            # Dessiner un arc pour le sourire
            if height > self.eyelids_happy_bottom_offset:
                happy_rect = pygame.Rect(x, bottom_y, width, self.eyelids_happy_bottom_offset * 2)
                pygame.draw.ellipse(self.surface, self.bg_color, happy_rect)
    
    def _animate_eyes(self):
        """Anime l'ouverture et la fermeture des yeux"""
        # Animation fluide de la hauteur des yeux
        if self.eye_l_height < self.eye_l_height_next:
            self.eye_l_height = min(self.eye_l_height + 3, self.eye_l_height_next)
        elif self.eye_l_height > self.eye_l_height_next:
            self.eye_l_height = max(self.eye_l_height - 3, self.eye_l_height_next)
        
        if self.eye_r_height < self.eye_r_height_next:
            self.eye_r_height = min(self.eye_r_height + 3, self.eye_r_height_next)
        elif self.eye_r_height > self.eye_r_height_next:
            self.eye_r_height = max(self.eye_r_height - 3, self.eye_r_height_next)
    
    def _handle_auto_blink(self, current_time):
        """Gère le clignement automatique des yeux"""
        if current_time - self.blink_timer > (self.blink_interval + randint(0, self.blink_interval_variation)) * 1000:
            self.blink()
            self.blink_timer = current_time
    
    def _handle_idle(self, current_time):
        """Gère le mouvement aléatoire des yeux en mode idle"""
        if current_time - self.idle_timer > (self.idle_interval + randint(0, self.idle_interval_variation)) * 1000:
            # Choisir une position aléatoire
            positions = [CENTER, N, NE, E, SE, S, SW, W, NW]
            self.look(positions[randint(0, len(positions) - 1)])
            self.idle_timer = current_time
    
    def _handle_laughing(self, current_time):
        """Gère l'animation de rigolade (yeux qui tremblent)"""
        # Faire trembler les yeux de gauche à droite
        elapsed = current_time - self.laugh_timer
        frequency = 10  # Vitesse de tremblement
        amplitude = 3   # Amplitude du tremblement
        
        self.laugh_shake_offset = int(amplitude * math.sin(elapsed / frequency))
        
        # Cligner rapidement pendant la rigolade
        if elapsed % 300 < 150:  # Cligne toutes les 300ms
            self.eye_l_height_next = self.eye_l_height_default
            self.eye_r_height_next = self.eye_r_height_default
        else:
            self.eye_l_height_next = int(self.eye_l_height_default * 0.3)
            self.eye_r_height_next = int(self.eye_r_height_default * 0.3)
    
    def _handle_crying(self, current_time):
        """Gère l'animation de pleurs (larmes qui tombent)"""
        # Créer une nouvelle larme périodiquement
        if current_time - self.cry_timer > 500:  # Nouvelle larme toutes les 500ms
            # Larme sous l'œil gauche
            self.tears.append({
                'x': self.eye_l_x + self.eye_l_width // 2,
                'y': self.eye_l_y + self.eye_l_height,
                'size': 2,
                'speed': 1
            })
            # Larme sous l'œil droit
            self.tears.append({
                'x': self.eye_r_x + self.eye_r_width // 2,
                'y': self.eye_r_y + self.eye_r_height,
                'size': 2,
                'speed': 1
            })
            self.cry_timer = current_time
        
        # Faire tomber les larmes
        for tear in self.tears[:]:
            tear['y'] += tear['speed']
            tear['speed'] += 0.1  # Accélération
            
            # Supprimer les larmes qui sortent de l'écran
            if tear['y'] > self.screen_height:
                self.tears.remove(tear)
    
    def _handle_angry(self, current_time):
        """Gère l'animation de colère (yeux rouges qui pulsent en croix)"""
        # Effet de pulse : les yeux s'élargissent et se rétrécissent en hauteur
        elapsed = current_time - self.angry_timer
        frequency = 15  # Vitesse du pulse
        amplitude = 8   # Amplitude du pulse
        
        # Pulse sinusoïdal (grand/petit en croix)
        self.angry_pulse = int(amplitude * math.sin(elapsed / frequency))
    
    def _draw_sun_rays(self, center_x, center_y, eye_width):
        """Dessine les rayons de soleil autour de l'œil (sourire jaune)"""
        ray_length = eye_width // 2 + 8
        num_rays = 8
        
        for i in range(num_rays):
            angle = (i * 360 / num_rays) * (3.14159 / 180)
            start_x = center_x + int((eye_width // 2 + 2) * math.cos(angle))
            start_y = center_y + int((eye_width // 2 + 2) * math.sin(angle))
            end_x = center_x + int(ray_length * math.cos(angle))
            end_y = center_y + int(ray_length * math.sin(angle))
            
            pygame.draw.line(self.surface, self.happy_color, 
                           (start_x, start_y), (end_x, end_y), 2)
    
    def _draw_disgust_arcs(self, x, y, width, height):
        """Dessine des arcs vers le bas pour le dégoût (vert)"""
        # Arc en bas de l'œil
        arc_rect = pygame.Rect(x, y + height - 10, width, 20)
        pygame.draw.arc(self.surface, self.disgust_color, arc_rect, 0, 3.14159, 3)
        
        # Petit arc supplémentaire
        arc_rect2 = pygame.Rect(x + 5, y + height - 5, width - 10, 15)
        pygame.draw.arc(self.surface, self.disgust_color, arc_rect2, 0, 3.14159, 2)
    
    def blink(self):
        """Fait cligner les yeux"""
        self.eye_l_height_next = 1
        self.eye_r_height_next = 1
        pygame.time.set_timer(pygame.USEREVENT + 1, 150, 1)  # Rouvrir après 150ms
    
    def open_eyes(self):
        """Ouvre les yeux"""
        self.eye_l_height_next = self.eye_l_height_default
        self.eye_r_height_next = self.eye_r_height_default
    
    def close_eyes(self):
        """Ferme les yeux"""
        self.eye_l_height_next = 1
        self.eye_r_height_next = 1
    
    def look(self, position):
        """
        Fait regarder les yeux dans une direction
        
        Args:
            position: Direction (N, S, E, W, NE, NW, SE, SW, CENTER)
        """
        self._position = position
        # Pour simplifier, on ne déplace pas vraiment les yeux dans cette version
        # Cela peut être ajouté comme exercice !
    
    def set_mood(self, mood):
        """
        Change l'humeur des yeux
        
        Args:
            mood: HAPPY, TIRED, ANGRY, DEFAULT, etc.
        """
        self._mood = mood
        
        # Réinitialiser toutes les paupières et états
        self.eyelids_tired_height = 0
        self.eyelids_angry_height = 0
        self.eyelids_happy_bottom_offset = 0
        self.happy = False
        self.tired = False
        self.angry = False
        self.disgust = False
        self.sad = False
        self.crying = False
        self.laughing = False
        
        if mood == HAPPY:
            self.happy = True
            self.eyelids_happy_bottom_offset = self.eyelids_happy_bottom_offset_max
        elif mood == TIRED:
            self.tired = True
            self.eyelids_tired_height = int(self.eye_l_height_default / 3)
        elif mood == ANGRY:
            self.angry = True
            self.eyelids_angry_height = int(self.eye_l_height_default / 2)  # Plus prononcé
            self.angry_timer = pygame.time.get_ticks()
            self.angry_pulse = 0
        elif mood == DISGUST:
            self.disgust = True
            self.eyelids_tired_height = int(self.eye_l_height_default / 4)
            self.eyelids_angry_height = int(self.eye_l_height_default / 4)
        elif mood == SAD:
            self.sad = True
            self.eyelids_tired_height = int(self.eye_l_height_default / 2)
        elif mood == CRYING:
            self.crying = True
            self.sad = True
            self.eyelids_tired_height = int(self.eye_l_height_default / 2)
            self.tears = []  # Réinitialiser les larmes
            self.cry_timer = pygame.time.get_ticks()
        elif mood == LAUGHING:
            self.laughing = True
            self.happy = True
            self.eyelids_happy_bottom_offset = self.eyelids_happy_bottom_offset_max
            self.laugh_timer = pygame.time.get_ticks()
    
    def set_auto_blinker(self, state, interval=3, variation=2):
        """
        Active/désactive le clignement automatique
        
        Args:
            state: ON ou OFF
            interval: Intervalle de base en secondes
            variation: Variation aléatoire en secondes
        """
        self.auto_blinker = (state == ON)
        self.blink_interval = interval
        self.blink_interval_variation = variation
        if self.auto_blinker:
            self.blink_timer = pygame.time.get_ticks()
    
    def set_idle_mode(self, state, interval=2, variation=3):
        """
        Active/désactive le mode idle (yeux qui bougent)
        
        Args:
            state: ON ou OFF
            interval: Intervalle de base en secondes
            variation: Variation aléatoire en secondes
        """
        self.idle = (state == ON)
        self.idle_interval = interval
        self.idle_interval_variation = variation
        if self.idle:
            self.idle_timer = pygame.time.get_ticks()
    
    def eyes_width(self, left=None, right=None):
        """Définit la largeur des yeux"""
        if left is not None:
            self.eye_l_width = left
            self.eye_l_width_default = left
        if right is not None:
            self.eye_r_width = right
            self.eye_r_width_default = right
    
    def eyes_height(self, left=None, right=None):
        """Définit la hauteur des yeux"""
        if left is not None:
            self.eye_l_height_default = left
            self.eye_l_height_next = left
        if right is not None:
            self.eye_r_height_default = right
            self.eye_r_height_next = right
