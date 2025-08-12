extends CanvasLayer
class_name PauseMenu

@onready var root: Control = $Control

func _ready() -> void:
	root.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	var v := !root.visible
	root.visible = v
	get_tree().paused = v

func _on_resume_pressed() -> void: toggle_pause()
func _on_save_pressed() -> void:
	var save := get_node("../SaveLoad")
	if save: save.save_state({})
func _on_quit_pressed() -> void:
	get_tree().quit()
