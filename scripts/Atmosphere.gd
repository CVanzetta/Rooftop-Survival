extends Node
class_name Atmosphere

@onready var env: WorldEnvironment = $"../WorldEnvironment"
@onready var weather: Weather = $"../Weather"
@onready var daynight: DayNight = $"../DayNight"

func _process(_delta: float) -> void:
	if env == null or env.environment == null:
		return
	var e: Environment = env.environment
	var is_night: bool = (daynight.time_of_day < 6.0 or daynight.time_of_day > 20.0)
	var overcast: float = clamp(float(weather.profile.get("light", 0.6)), 0.2, 1.0)

	e.ambient_light_energy = 0.25 if is_night else 0.8 * overcast
	e.tonemap_exposure = 0.6 if is_night else 0.9 * overcast
