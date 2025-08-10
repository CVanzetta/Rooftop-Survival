extends Node
class_name SaveLoad

@onready var stats: Stats = get_node("../Stats")
@onready var inv: Inventory = get_node("../Inventory")
@onready var water: WaterSystem = get_node("../WaterSystem")

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("save"): 
        save_state(_snapshot())
        print("Jeu sauvegardé!")
    if event.is_action_pressed("load"): 
        _apply(load_state())
        print("Jeu chargé!")

func _snapshot() -> Dictionary:
    return {
        "stats": {"hunger":stats.hunger,"thirst":stats.thirst,"energy":stats.energy,"body_temp":stats.body_temp},
        "inv": inv.items,
        "water": {"raw": water.water_raw, "clean": water.water_clean}
    }

func _apply(s: Dictionary) -> void:
    if s.size() == 0:
        print("Aucune sauvegarde trouvée!")
        return
    if s.has("stats"):
        var st: Variant = s.stats
        stats.hunger = st.hunger
        stats.thirst = st.thirst
        stats.energy = st.energy
        stats.body_temp = st.body_temp
    if s.has("inv"): inv.items = s.inv
    if s.has("water"):
        water.water_raw = s.water.raw
        water.water_clean = s.water.clean

func save_state(state: Dictionary) -> void:
    var f: FileAccess = FileAccess.open("user://save.json", FileAccess.WRITE)
    f.store_string(JSON.stringify(state))

func load_state() -> Dictionary:
    if !FileAccess.file_exists("user://save.json"): return {}
    var f: FileAccess = FileAccess.open("user://save.json", FileAccess.READ)
    return JSON.parse_string(f.get_as_text())
