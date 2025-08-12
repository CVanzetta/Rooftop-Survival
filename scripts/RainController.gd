extends Node
class_name RainController

@onready var weather: Weather = $"../Weather"
@onready var rain_fx: GPUParticles3D = $"../RainFX"
@onready var rain_audio: AudioStreamPlayer = $"../RainAudio"

func _process(_delta: float) -> void:
	var r := float(weather.profile.get("rain", 0.0))
	var on := r > 0.1
	if rain_fx:
		rain_fx.emitting = on
		if on:
			rain_fx.amount = int(1500.0 * clamp(r, 0.2, 1.0))
	if rain_audio:
		if on and !rain_audio.playing: rain_audio.play()
		if !on and rain_audio.playing: rain_audio.stop()
