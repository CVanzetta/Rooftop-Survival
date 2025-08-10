extends Node
class_name SaveLoad

func save_state(state: Dictionary) -> void:
    var f = FileAccess.open("user://save.json", FileAccess.WRITE)
    f.store_string(JSON.stringify(state))

func load_state() -> Dictionary:
    if !FileAccess.file_exists("user://save.json"): return {}
    var f = FileAccess.open("user://save.json", FileAccess.READ)
    return JSON.parse_string(f.get_as_text())
