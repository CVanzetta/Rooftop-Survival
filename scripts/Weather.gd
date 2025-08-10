extends Node
class_name Weather

var profile := {"id":"overcast","temp":15.0,"rain":0.2,"wind":0.3,"light":0.6}
var target_profile := profile
var transition_time := 0.0
var transition_total := 1.0

var profiles: Array = []
var transition_minutes := 20

func _ready() -> void:
    var f := FileAccess.open("res://data/weather_profiles.json", FileAccess.READ)
    if f:
        var j: Variant = JSON.parse_string(f.get_as_text())
        profiles = j.get("profiles", [])
        transition_minutes = j.get("transition_minutes", 20)
        _pick_new_target()

func _process(delta: float) -> void:
    if transition_time < transition_total:
        transition_time += delta
        var t: float = clamp(transition_time/transition_total, 0.0, 1.0)
        profile.temp = lerp(profile.temp, target_profile.temp, t)
        profile.rain = lerp(profile.rain, target_profile.rain, t)
        profile.wind = lerp(profile.wind, target_profile.wind, t)
        profile.light = lerp(profile.light, target_profile.light, t)
    else:
        _pick_new_target()

func _pick_new_target() -> void:
    if profiles.size() == 0:
        return
    target_profile = profiles[randi() % profiles.size()]
    transition_time = 0.0
    transition_total = float(transition_minutes * 60)
