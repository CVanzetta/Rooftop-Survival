# Rooftop Survival (MVP)
Prototype Godot 4 chill survival sur un toit : faim/soif/énergie/température, météo, collecte pluie, craft JSON.

## Prérequis
- Godot 4.x (GDScript)

## Lancer
1. Ouvrir le repo dans Godot.
2. Définir `scenes/Main.tscn` comme scène principale (Project > Project Settings > Run).
3. F5 pour lancer.

## Contrôles

- **Déplacement** : ZQSD ou flèches directionnelles
- **Sauvegarde** : F5
- **Chargement** : F9
- **Pause** : Esc (menu avec Resume, Save, Quit)
- **Interface** : HUD avec jauges de survie et gestion de l'eau

## Scène de test

- **Caméra isométrique** : vue d'ensemble du toit avec angle incliné
- **Contrôles** : ZQSD/Flèches = déplacement sur le toit
- **Environnement** : Sol placeholder avec éclairage directionnel et environnement ambient

## Atmosphere & Comfort

- **Cycle jour/nuit** : 24 minutes réelles = 24 heures de jeu (configurable)
- **Pluie visible/sonore** : particules et audio synchronisés avec la météo
- **Effets de température** : influence subtile sur soif/énergie (pas punitif)
- **Audio d'ambiance** : sons différents jour/nuit
- **Placeholders audio** : rain_loop.ogg et ambience_night.ogg (OK si vides)

## Fonctionnalités

- **Déplacement 3D** du joueur sur le toit
- **Jauges de survie** : faim, soif, énergie, température corporelle
- **Système météo** : collecte d'eau de pluie automatique
- **Filtrage d'eau** : transformer eau brute en eau potable (coûte du charbon)
- **Sauvegarde/chargement** : persistance de l'état du jeu + heure du jour

## Roadmap MVP

- ✅ S1: mouvements + HUD + jauges
- 🔄 S2: météo + cycle jour/nuit + collecte pluie
- ⏳ S3: inventaire + craft T1 depuis `data/recipes.json`
