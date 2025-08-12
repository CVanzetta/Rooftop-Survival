extends Node
class_name AudioManager

@onready var daynight: DayNight = $"../DayNight"
@onready var amb: AudioStreamPlayer = $"../Ambience"

func _process(_delta: float) -> void:
	if !amb: return
	var night := daynight.time_of_day < 6.0 or daynight.time_of_day > 20.0
	amb.volume_db = -8.0 if night else -12.0
	if !amb.playing: amb.play()
