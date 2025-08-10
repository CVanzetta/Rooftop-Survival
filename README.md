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
- **Interface** : HUD avec jauges de survie et gestion de l'eau

## Fonctionnalités
- **Déplacement 3D** du joueur sur le toit
- **Jauges de survie** : faim, soif, énergie, température corporelle
- **Système météo** : collecte d'eau de pluie automatique
- **Filtrage d'eau** : transformer eau brute en eau potable (coûte du charbon)
- **Sauvegarde/chargement** : persistance de l'état du jeu

## Roadmap MVP
- ✅ S1: mouvements + HUD + jauges
- 🔄 S2: météo + cycle jour/nuit + collecte pluie
- ⏳ S3: inventaire + craft T1 depuis `data/recipes.json`
