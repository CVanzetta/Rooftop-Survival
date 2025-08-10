extends CanvasLayer
class_name HUD

@onready var pb_hunger: ProgressBar = $Control/VBoxContainer/HBoxHunger/PBHunger
@onready var pb_thirst: ProgressBar = $Control/VBoxContainer/HBoxThirst/PBThirst
@onready var pb_energy: ProgressBar = $Control/VBoxContainer/HBoxEnergy/PBEnergy
@onready var pb_temp: ProgressBar = $Control/VBoxContainer/HBoxTemp/PBTemp
@onready var btn_filter: Button = $Control/VBoxContainer/BtnFilter
@onready var lbl_water: Label = $Control/VBoxContainer/LblWater

var stats: Stats
var water_system: WaterSystem

func _ready() -> void:
    stats = get_tree().get_first_node_in_group("stats") as Stats
    water_system = get_node("../WaterSystem") as WaterSystem
    if btn_filter:
        btn_filter.pressed.connect(_on_filter_pressed)

func _process(delta: float) -> void:
    if stats == null: return
    pb_hunger.value = stats.hunger
    pb_thirst.value = stats.thirst
    pb_energy.value = stats.energy
    pb_temp.value = clamp((stats.body_temp - 34.0) * 33.3, 0.0, 100.0) # 34-37°C
    
    if water_system:
        lbl_water.text = "Eau: %.1fL brute / %.1fL propre" % [water_system.water_raw, water_system.water_clean]
        btn_filter.disabled = !water_system.can_filter_1l()

func _on_filter_pressed() -> void:
    if water_system and water_system.filter_1l():
        print("1L d'eau filtrée !")
