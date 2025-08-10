extends CharacterBody3D
class_name Player

@export var speed := 5.0

func _physics_process(delta: float) -> void:
    var dir := Vector3.ZERO
    if Input.is_action_pressed("ui_up"): dir.z -= 1
    if Input.is_action_pressed("ui_down"): dir.z += 1
    if Input.is_action_pressed("ui_left"): dir.x -= 1
    if Input.is_action_pressed("ui_right"): dir.x += 1
    if dir != Vector3.ZERO:
        dir = dir.normalized()
    velocity.x = dir.x * speed
    velocity.z = dir.z * speed
    move_and_slide()
