Contexte

Repo: <REPO_URL>

Crée la branche feat/atmo-comfort-1, PR vers main — titre: Atmosphere & Comfort Pack 1

Objectif: cycle jour/nuit + météo visible (pluie) + ambiance sonore + température (effets doux) + pause menu + save/load de l’heure.

Tâches
1) Cycle jour/nuit
Fichier: scripts/DayNight.gd

gdscript
Copier le code
extends Node
class_name DayNight

@export var minutes_per_day := 24.0
var time_of_day := 22.0 # start late night

@onready var sun: DirectionalLight3D = $"../Sun"

func _process(delta: float) -> void:
    var spd := 24.0 / (minutes_per_day * 60.0)
    time_of_day = fmod(time_of_day + spd * delta, 24.0)
    if sun:
        var t := time_of_day / 24.0
        sun.rotation_degrees.x = lerp(-15.0, 205.0, t)
        var is_night := time_of_day < 6.0 or time_of_day > 20.0
        sun.light_energy = is_night ? 0.25 : 1.0
Instancier DayNight dans scenes/Main.tscn (sibling de Sun).

2) Atmosphère / WorldEnvironment
Fichier: scripts/Atmosphere.gd

gdscript
Copier le code
extends Node
class_name Atmosphere

@onready var env: WorldEnvironment = $"../WorldEnvironment"
@onready var weather: Weather = $"../Weather"
@onready var daynight: DayNight = $"../DayNight"

func _process(_delta: float) -> void:
    if !env or !env.environment: return
    var e := env.environment
    var is_night := daynight.time_of_day < 6.0 or daynight.time_of_day > 20.0
    var overcast := clamp(weather.profile.get("light", 0.6), 0.2, 1.0)
    e.ambient_light_energy = is_night ? 0.25 : 0.8 * overcast
    e.tonemap_exposure = is_night ? 0.6 : 0.9 * overcast
Ajouter un WorldEnvironment si manquant (tu en as déjà un via PR #4 → juste brancher le script).

3) Pluie visible + son
Ajouter sous Main :

GPUParticles3D nommé RainFX (emitter au‑dessus du toit, large AABB).

AudioStreamPlayer nommé RainAudio (placeholder audio assets/sfx/rain_loop.ogg ; si absent, laisser non assigné).

Fichier: scripts/RainController.gd

gdscript
Copier le code
extends Node
class_name RainController

@onready var weather: Weather = $"../Weather"
@onready var rain_fx: GPUParticles3D = $"../RainFX"
@onready var rain_audio: AudioStreamPlayer = $"../RainAudio"

func _process(_delta: float) -> void:
    var r := float(weather.profile.get("rain", 0.0))
    var on := r > 0.1
    if rain_fx:
        rain_fx.emitting = on
        if on:
            rain_fx.amount = int(1500.0 * clamp(r, 0.2, 1.0))
    if rain_audio:
        if on and !rain_audio.playing: rain_audio.play()
        if !on and rain_audio.playing: rain_audio.stop()
Instancier RainController dans Main.

4) Température (effets doux, jamais punitif)
Adapter scripts/Stats.gd : passer les const modulables en var et exposer des multiplicateurs.

gdscript
Copier le code
# Stats.gd (extrait)
var hunger: float = 0.0
var thirst: float = 0.0
var energy: float = 100.0
var body_temp: float = 36.8

var HUNGER_RATE := 0.35
var THIRST_RATE := 0.60
var ENERGY_REGEN := 30.0

var thirst_mult := 1.0
var energy_regen_mult := 1.0

func _process(delta: float) -> void:
    hunger = clamp(hunger + HUNGER_RATE * delta, 0.0, 100.0)
    thirst = clamp(thirst + (THIRST_RATE * thirst_mult) * delta, 0.0, 100.0)
    energy = clamp(energy + (ENERGY_REGEN * energy_regen_mult) * delta, 0.0, 100.0)
Nouveau fichier: scripts/TemperatureSystem.gd

gdscript
Copier le code
extends Node
class_name TemperatureSystem

@onready var weather: Weather = $"../Weather"
@onready var daynight: DayNight = $"../DayNight"
@onready var stats: Stats = $"../Stats"

func _process(_delta: float) -> void:
    var base := float(weather.profile.get("temp", 15.0))
    if daynight.time_of_day < 6.0 or daynight.time_of_day > 20.0:
        base -= 2.0
    # map 8..28°C → modulateurs 0.9..1.15 (subtil)
    var thirst_mult := clamp(remap(base, 8.0, 28.0, 0.9, 1.15), 0.85, 1.2)
    var energy_mult := clamp(remap(base, 8.0, 28.0, 0.95, 1.0), 0.85, 1.1)
    stats.thirst_mult = thirst_mult
    stats.energy_regen_mult = 1.0 / energy_mult
Instancier TemperatureSystem dans Main.

5) Audio d’ambiance nuit/jour
Ajouter AudioStreamPlayer sous Main nommé Ambience (placeholder assets/sfx/ambience_night.ogg si présent).

Fichier: scripts/AudioManager.gd

gdscript
Copier le code
extends Node
class_name AudioManager

@onready var daynight: DayNight = $"../DayNight"
@onready var amb: AudioStreamPlayer = $"../Ambience"

func _process(_delta: float) -> void:
    if !amb: return
    var night := daynight.time_of_day < 6.0 or daynight.time_of_day > 20.0
    amb.volume_db = night ? -8.0 : -12.0
    if !amb.playing: amb.play()
Instancier AudioManager dans Main.

6) Pause Menu (Esc)
scenes/ui/PauseMenu.tscn (CanvasLayer + Control simple avec 3 boutons: Resume, Save, Quit).

scripts/PauseMenu.gd

gdscript
Copier le code
extends CanvasLayer
class_name PauseMenu

@onready var root: Control = $Control

func _ready() -> void:
    root.visible = false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        toggle_pause()

func toggle_pause() -> void:
    var v := !root.visible
    root.visible = v
    get_tree().paused = v

func _on_resume_pressed() -> void: toggle_pause()
func _on_save_pressed() -> void:
    var save := get_node("../SaveLoad")
    if save: save.save_state({})
func _on_quit_pressed() -> void:
    get_tree().quit()
Brancher les boutons aux fonctions. Ajouter la scène PauseMenu dans Main.

7) Save/Load — heure du jour
Étendre scripts/SaveLoad.gd pour stocker/restaurer DayNight.time_of_day :

gdscript
Copier le code
func save_state(state: Dictionary) -> void:
    var d := get_node("../DayNight")
    if d:
        state["time_of_day"] = d.time_of_day
    # merge avec autres états existants (stats, inventory, water)
    var f = FileAccess.open("user://save.json", FileAccess.WRITE)
    f.store_string(JSON.stringify(state))

func load_state() -> Dictionary:
    if !FileAccess.file_exists("user://save.json"): return {}
    var f = FileAccess.open("user://save.json", FileAccess.READ)
    var s: Dictionary = JSON.parse_string(f.get_as_text())
    var d := get_node("../DayNight")
    if d and s.has("time_of_day"):
        d.time_of_day = float(s["time_of_day"])
    return s
8) README
Section “Atmosphere & Comfort” (cycle jour/nuit, pluie visible/sonore, Esc = pause).

Mention placeholders audio (OK s’ils sont vides).

Commits (Conventional)
feat: add day-night cycle and environment controller

feat: add rain particles and rain audio synced to weather

feat: add gentle temperature effects on thirst/energy

feat: add ambience loop and pause menu (esc)

feat: persist time_of_day in save/load

docs: update README (atmosphere & controls)

Critères d’acceptation
La lumière/exposition varient en continu (24 min = 24h par défaut).

Quand Weather.profile.rain > 0.1 → particules pluie + rain_loop démarrent, sinon s’arrêtent.

Température influence légèrement la soif/énergie (pas de “game over”, pas de gros malus).

Esc ouvre/ferme un menu pause fonctionnel.

Sauvegarde/chargement restaurent l’heure du jour.

