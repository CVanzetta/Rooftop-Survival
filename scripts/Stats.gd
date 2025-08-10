extends Node
class_name Stats

var hunger: float = 0.0
var thirst: float = 0.0
var energy: float = 100.0
var body_temp: float = 36.8

const HUNGER_RATE := 0.35
const THIRST_RATE := 0.60
const ENERGY_REGEN := 30.0

func _process(delta: float) -> void:
    hunger = clamp(hunger + HUNGER_RATE * delta, 0.0, 100.0)
    thirst = clamp(thirst + THIRST_RATE * delta, 0.0, 100.0)
    # energy regen simple si inactif (placeholder)
    energy = clamp(energy + (ENERGY_REGEN * 0.1) * delta, 0.0, 100.0)
