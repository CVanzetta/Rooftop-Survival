extends Node
class_name Stats

var hunger := 0.0
var thirst := 0.0
var energy := 100.0
var body_temp := 36.8

var HUNGER_RATE := 0.35
var THIRST_RATE := 0.60
var ENERGY_REGEN := 30.0

var thirst_mult := 1.0
var energy_regen_mult := 1.0

func _ready() -> void:
    add_to_group("stats")

func _process(delta: float) -> void:
    hunger = clamp(hunger + HUNGER_RATE * delta, 0.0, 100.0)
    thirst = clamp(thirst + (THIRST_RATE * thirst_mult) * delta, 0.0, 100.0)
    energy = clamp(energy + (ENERGY_REGEN * energy_regen_mult) * delta, 0.0, 100.0)
