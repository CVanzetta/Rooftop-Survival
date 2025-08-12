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
