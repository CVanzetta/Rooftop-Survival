extends Node
class_name Stats

var hunger := 0.0
var thirst := 0.0
var energy := 100.0
var body_temp := 36.8

const HUNGER_RATE := 0.20
const THIRST_RATE := 0.35
const ENERGY_REGEN := 15.0

func _ready() -> void:
    add_to_group("stats")

func _process(delta: float) -> void:
    hunger = clamp(hunger + HUNGER_RATE * delta, 0.0, 100.0)
    thirst = clamp(thirst + THIRST_RATE * delta, 0.0, 100.0)
    energy = clamp(energy + (ENERGY_REGEN * 0.1) * delta, 0.0, 100.0)
