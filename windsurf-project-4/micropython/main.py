"""
Programme principal pour MicroPython
Robot avec sourire style Cozmo sur écran OLED

Adapté de: https://github.com/mchobby/micropython-roboeyes
"""

from machine import I2C, Pin
from roboeyes import RoboEyes, HAPPY, ON, DEFAULT
import ssd1306
import time

def main():
    """Programme principal pour le robot"""
    
    print("🤖 Démarrage du robot...")
    
    # Configuration I2C pour Raspberry Pi Pico
    # Adaptez les pins selon votre carte !
    try:
        # Pour Raspberry Pi Pico
        i2c = I2C(1, sda=Pin(6), scl=Pin(7), freq=400000)
    except:
        # Pour ESP32 (GPIO 21=SDA, 22=SCL)
        i2c = I2C(0, sda=Pin(21), scl=Pin(22), freq=400000)
    
    # Scanner les périphériques I2C
    devices = i2c.scan()
    print(f"Périphériques I2C trouvés: {[hex(d) for d in devices]}")
    
    # Adresse de l'écran OLED (0x3C ou 0x3D selon le modèle)
    oled_addr = 0x3C
    if 0x3D in devices:
        oled_addr = 0x3D
    
    print(f"Utilisation de l'adresse OLED: {hex(oled_addr)}")
    
    # Initialiser l'écran OLED 128x64
    lcd = ssd1306.SSD1306_I2C(128, 64, i2c, addr=oled_addr)
    
    # Fonction de callback pour afficher sur l'écran
    def robo_show(roboeyes):
        lcd.show()
    
    # Créer les yeux du robot
    robo = RoboEyes(lcd, 128, 64, frame_rate=30, on_show=robo_show)
    
    # Configuration des yeux
    robo.eyes_width(28, 28)   # Yeux un peu plus petits
    robo.eyes_height(28, 28)
    
    # Activer le clignement automatique (toutes les 3-5 secondes)
    robo.set_auto_blinker(ON, 3, 2)
    
    # Activer le mode idle (yeux qui bougent)
    # robo.set_idle_mode(ON, 2, 2)
    
    print("✅ Robot initialisé !")
    print("😊 Affichage du sourire...")
    
    # Ouvrir les yeux
    robo.open_eyes()
    
    # Attendre un peu que les yeux s'ouvrent
    for _ in range(20):
        robo.update()
        time.sleep(0.05)
    
    # Faire sourire le robot (comme Cozmo!)
    robo.set_mood(HAPPY)
    print("🤖 Le robot sourit maintenant !")
    
    # Boucle principale
    try:
        while True:
            robo.update()
            time.sleep(0.01)  # Petit délai pour ne pas surcharger le CPU
            
    except KeyboardInterrupt:
        print("\n👋 Arrêt du robot")
        lcd.fill(0)
        lcd.show()

# Lancer le programme
if __name__ == "__main__":
    main()
