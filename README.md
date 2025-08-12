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

- ✅ S2: météo + cycle jour/nuit + collecte pluie + Atmosphere & Comfort Pack 1
- ✅ S3: Visuals Pack 0 (ciel, fog, wetness, props)
- ⏳ S4: inventaire + craft T1 depuis `data/recipes.json`

## Visuals Pack 0 🎨

**Améliorations visuelles immersives** :

### 🌌 **Environnement**
- **Ciel procédural** : Tons bleu nuit (#263340 → #3a4552) avec sky_energy=0.9
- **Fog volumétrique** : Brouillard doux (density=0.02, height=10m) pour l'ambiance
- **Post-processing** : ACES tonemap, SSAO subtil, Bloom discret

### 🏢 **Props sur le toit**
- **Parapets** : 4 murets de protection autour du toit (gris #3a3f44)
- **Unité HVAC** : Système de ventilation low-poly empilé (métal #6f7a84)
- **Réservoir d'eau** : Tank cylindrique pour l'immersion (#5a6a7a)

### 💧 **Shader Wetness**
- **Sol dynamique** : S'assombrit et devient brillant sous la pluie
- **Transition progressive** : Mouillage rapide (3s), séchage lent (séchage en 2x plus lent)
- **Automatique** : Lié au système météo (`Weather.profile.rain`)

### 🎭 **Interface**
- **Vignette discrète** : Effet d'assombrissement des bords (strength=0.35)
- **Particules de pluie** : 1200 particules optimisées, emission_box 30x30m

### 🧪 **Tester les effets**
Pour forcer la pluie et voir l'effet de mouillage :
1. Modifier `data/weather_profiles.json` : `"rain": 0.9`
2. Relancer le jeu → Le sol devient sombre et brillant
3. Remettre `"rain": 0.0` → Le sol sèche progressivement

**Résultat** : Environnement visuel crédible avec ambiance immersive et effets météo réactifs.

