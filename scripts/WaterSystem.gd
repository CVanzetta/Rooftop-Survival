extends Node
class_name WaterSystem

var water_raw := 0.0     # litres
var water_clean := 2.0   # litres de départ
@export var collector_rate := 0.02  # L/s par pluie modérée
@onready var weather: Weather = get_node("../Weather")
@onready var inventory: Inventory = get_node("../Inventory")

func _process(delta: float) -> void:
    if weather and weather.profile.get("rain", 0.0) > 0.1:
        var coef: float = weather.profile.rain # 0..1
        water_raw += collector_rate * coef * delta

func can_filter_1l() -> bool:
    return water_raw >= 1.0 and inventory.has("charcoal", 1)

func filter_1l() -> bool:
    if !can_filter_1l():
        return false
    water_raw -= 1.0
    water_clean += 1.0
    inventory.remove("charcoal", 1)
    return true
