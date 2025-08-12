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
