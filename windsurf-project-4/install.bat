@echo off
REM Script d'installation pour Windows

echo.
echo ================================
echo Installation du Projet Robot
echo ================================
echo.

echo Verification de Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Python n'est pas installe !
    echo Installez Python depuis https://www.python.org/
    pause
    exit /b 1
)

echo [OK] Python trouve
echo.

echo Installation des dependances...
pip install -r requirements.txt

if %errorlevel% equ 0 (
    echo.
    echo ================================
    echo Installation reussie !
    echo ================================
    echo.
    echo Pour demarrer, lancez :
    echo    python robot_smile.py
    echo.
    echo Consultez GUIDE_DEMARRAGE.md pour plus d'infos
) else (
    echo.
    echo [ERREUR] Probleme lors de l'installation
    echo Essayez manuellement : pip install pygame numpy
)

echo.
pause
