extends Node
class_name WetnessController

@onready var weather: Weather = $"../Weather"
@onready var roof: Node3D = $"../World/RoofScene/Floor"
var wetness: float = 0.0

func _process(delta: float) -> void:
	var rain: float = float(weather.profile.get("rain", 0.0))
	var target: float = clamp(rain, 0.0, 1.0)
	# séchage lent, mouillage un peu plus rapide
	var rate: float = (3.0 if target > wetness else 0.5)
	wetness = clamp(lerp(wetness, target, rate * delta), 0.0, 1.0)
	if roof and roof.get_surface_override_material_count() > 0:
		var mat: Material = roof.get_surface_override_material(0)
		if mat and mat.has_method("set_shader_parameter"):
			mat.set_shader_parameter("wetness", wetness)
