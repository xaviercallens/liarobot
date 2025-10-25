"""
Bibliothèque RoboEyes pour MicroPython
Version simplifiée adaptée de: https://github.com/mchobby/micropython-roboeyes

Pour écran OLED SSD1306 avec FrameBuffer
"""

from micropython import const
from random import randint
import time

# Constantes pour les humeurs
DEFAULT = const(0)
TIRED = const(1)
ANGRY = const(2)
HAPPY = const(3)
FROZEN = const(4)
SCARY = const(5)
CURIOUS = const(6)

# Constantes ON/OFF
ON = const(1)
OFF = const(0)

# Positions
N = const(1)
NE = const(2)
E = const(3)
SE = const(4)
S = const(5)
SW = const(6)
W = const(7)
NW = const(8)
CENTER = const(0)


class RoboEyes:
    """Classe pour dessiner des yeux de robot animés sur FrameBuffer"""
    
    def __init__(self, fb, width, height, frame_rate=20, on_show=None):
        """
        Initialise les yeux du robot
        
        Args:
            fb: FrameBuffer (ex: SSD1306)
            width: Largeur de l'écran
            height: Hauteur de l'écran
            frame_rate: Images par seconde
            on_show: Fonction callback pour afficher (ex: lcd.show)
        """
        assert on_show is not None, "on_show callback requis"
        
        self.fb = fb
        self.on_show = on_show
        self.screen_width = width
        self.screen_height = height
        
        # Timing
        self.frame_interval = 1000 // frame_rate
        self.fps_timer = 0
        
        # Humeur
        self._mood = DEFAULT
        self.tired = False
        self.angry = False
        self.happy = False
        
        # Géométrie
        self.space_between = 10
        
        # Œil gauche
        self.eye_l_width_default = 36
        self.eye_l_height_default = 36
        self.eye_l_width = self.eye_l_width_default
        self.eye_l_height = 1  # Commence fermé
        self.eye_l_height_next = self.eye_l_height_default
        self.eye_l_radius = 8
        
        # Œil droit
        self.eye_r_width_default = 36
        self.eye_r_height_default = 36
        self.eye_r_width = self.eye_r_width_default
        self.eye_r_height = 1
        self.eye_r_height_next = self.eye_r_height_default
        self.eye_r_radius = 8
        
        # Positions
        self.eye_l_x = int((width - (self.eye_l_width + self.space_between + self.eye_r_width)) / 2)
        self.eye_l_y = int((height - self.eye_l_height_default) / 2)
        self.eye_r_x = self.eye_l_x + self.eye_l_width + self.space_between
        self.eye_r_y = self.eye_l_y
        
        # Paupières
        self.eyelids_tired_height = 0
        self.eyelids_angry_height = 0
        self.eyelids_happy_bottom_offset = 0
        self.eyelids_happy_bottom_offset_max = int(self.eye_l_height_default / 2) + 3
        
        # Clignement auto
        self.auto_blinker = False
        self.blink_interval = 3
        self.blink_interval_variation = 2
        self.blink_timer = 0
        self.is_blinking = False
        
        # Mode idle
        self.idle = False
        self.idle_interval = 2
        self.idle_interval_variation = 3
        self.idle_timer = 0
        
        # Initialisation
        self.fb.fill(0)
        self.on_show(self)
    
    def update(self):
        """Met à jour et dessine les yeux"""
        current_time = time.ticks_ms()
        
        # Limiter le taux de rafraîchissement
        if time.ticks_diff(current_time, self.fps_timer) >= self.frame_interval:
            # Clignement automatique
            if self.auto_blinker:
                self._handle_auto_blink(current_time)
            
            # Mode idle
            if self.idle:
                self._handle_idle(current_time)
            
            # Animer
            self._animate_eyes()
            
            # Dessiner
            self.draw_eyes()
            self.fps_timer = current_time
    
    def draw_eyes(self):
        """Dessine les yeux"""
        self.fb.fill(0)
        
        # Dessiner les deux yeux
        self._draw_eye(self.eye_l_x, self.eye_l_y, self.eye_l_width, 
                      self.eye_l_height, self.eye_l_radius)
        self._draw_eye(self.eye_r_x, self.eye_r_y, self.eye_r_width, 
                      self.eye_r_height, self.eye_r_radius)
        
        self.on_show(self)
    
    def _draw_eye(self, x, y, width, height, radius):
        """Dessine un œil avec coins arrondis"""
        if height < 2:
            return
        
        # Rectangle principal
        self.fb.fill_rect(x + radius, y, width - 2 * radius, height, 1)
        self.fb.fill_rect(x, y + radius, width, height - 2 * radius, 1)
        
        # Coins arrondis (approximation)
        for i in range(radius):
            for j in range(radius):
                if i*i + j*j <= radius*radius:
                    # Coin haut-gauche
                    self.fb.pixel(x + radius - i, y + radius - j, 1)
                    # Coin haut-droit
                    self.fb.pixel(x + width - radius + i - 1, y + radius - j, 1)
                    # Coin bas-gauche
                    self.fb.pixel(x + radius - i, y + height - radius + j - 1, 1)
                    # Coin bas-droit
                    self.fb.pixel(x + width - radius + i - 1, y + height - radius + j - 1, 1)
        
        # Paupière supérieure (fatigue)
        if self.eyelids_tired_height > 0:
            self.fb.fill_rect(x, y, width, self.eyelids_tired_height, 0)
        
        # Paupière colère (en angle)
        if self.eyelids_angry_height > 0:
            for i in range(width):
                h = int(self.eyelids_angry_height * (1 - i / width))
                if h > 0:
                    self.fb.vline(x + i, y, h, 0)
        
        # Paupière bonheur (sourire en bas)
        if self.eyelids_happy_bottom_offset > 0:
            bottom_y = y + height - self.eyelids_happy_bottom_offset
            # Dessiner un arc pour le sourire
            for i in range(width):
                # Parabole pour le sourire
                offset = int(self.eyelids_happy_bottom_offset * (1 - (2*i/width - 1)**2))
                if offset > 0:
                    self.fb.vline(x + i, bottom_y + self.eyelids_happy_bottom_offset - offset, offset, 0)
    
    def _animate_eyes(self):
        """Anime l'ouverture/fermeture des yeux"""
        # Animation fluide
        if self.eye_l_height < self.eye_l_height_next:
            self.eye_l_height = min(self.eye_l_height + 3, self.eye_l_height_next)
        elif self.eye_l_height > self.eye_l_height_next:
            self.eye_l_height = max(self.eye_l_height - 3, self.eye_l_height_next)
        
        if self.eye_r_height < self.eye_r_height_next:
            self.eye_r_height = min(self.eye_r_height + 3, self.eye_r_height_next)
        elif self.eye_r_height > self.eye_r_height_next:
            self.eye_r_height = max(self.eye_r_height - 3, self.eye_r_height_next)
    
    def _handle_auto_blink(self, current_time):
        """Gère le clignement automatique"""
        interval_ms = (self.blink_interval + randint(0, self.blink_interval_variation)) * 1000
        if time.ticks_diff(current_time, self.blink_timer) > interval_ms:
            self.blink()
            self.blink_timer = current_time
    
    def _handle_idle(self, current_time):
        """Gère le mouvement aléatoire en mode idle"""
        interval_ms = (self.idle_interval + randint(0, self.idle_interval_variation)) * 1000
        if time.ticks_diff(current_time, self.idle_timer) > interval_ms:
            positions = [CENTER, N, E, S, W]
            # Pour simplifier, on ne déplace pas vraiment les yeux
            self.idle_timer = current_time
    
    def blink(self):
        """Fait cligner les yeux"""
        self.eye_l_height_next = 1
        self.eye_r_height_next = 1
        self.is_blinking = True
    
    def open_eyes(self):
        """Ouvre les yeux"""
        self.eye_l_height_next = self.eye_l_height_default
        self.eye_r_height_next = self.eye_r_height_default
        self.is_blinking = False
    
    def close_eyes(self):
        """Ferme les yeux"""
        self.eye_l_height_next = 1
        self.eye_r_height_next = 1
    
    def set_mood(self, mood):
        """Change l'humeur"""
        self._mood = mood
        
        # Réinitialiser
        self.eyelids_tired_height = 0
        self.eyelids_angry_height = 0
        self.eyelids_happy_bottom_offset = 0
        
        if mood == HAPPY:
            self.happy = True
            self.tired = False
            self.angry = False
            self.eyelids_happy_bottom_offset = self.eyelids_happy_bottom_offset_max
        elif mood == TIRED:
            self.happy = False
            self.tired = True
            self.angry = False
            self.eyelids_tired_height = int(self.eye_l_height_default / 3)
        elif mood == ANGRY:
            self.happy = False
            self.tired = False
            self.angry = True
            self.eyelids_angry_height = int(self.eye_l_height_default / 3)
        else:  # DEFAULT
            self.happy = False
            self.tired = False
            self.angry = False
    
    def set_auto_blinker(self, state, interval=3, variation=2):
        """Active/désactive le clignement automatique"""
        self.auto_blinker = (state == ON)
        self.blink_interval = interval
        self.blink_interval_variation = variation
        if self.auto_blinker:
            self.blink_timer = time.ticks_ms()
    
    def set_idle_mode(self, state, interval=2, variation=3):
        """Active/désactive le mode idle"""
        self.idle = (state == ON)
        self.idle_interval = interval
        self.idle_interval_variation = variation
        if self.idle:
            self.idle_timer = time.ticks_ms()
    
    def eyes_width(self, left=None, right=None):
        """Définit la largeur des yeux"""
        if left is not None:
            self.eye_l_width = left
            self.eye_l_width_default = left
        if right is not None:
            self.eye_r_width = right
            self.eye_r_width_default = right
        # Recalculer les positions
        self.eye_l_x = int((self.screen_width - (self.eye_l_width + self.space_between + self.eye_r_width)) / 2)
        self.eye_r_x = self.eye_l_x + self.eye_l_width + self.space_between
    
    def eyes_height(self, left=None, right=None):
        """Définit la hauteur des yeux"""
        if left is not None:
            self.eye_l_height_default = left
            self.eye_l_height_next = left
        if right is not None:
            self.eye_r_height_default = right
            self.eye_r_height_next = right
