extends CharacterBody3D
class_name Player

@export var speed := 5.0

func _physics_process(_delta: float) -> void:
    var dir := Vector3.ZERO
    if Input.is_action_pressed("move_up"): dir.z -= 1
    if Input.is_action_pressed("move_down"): dir.z += 1
    if Input.is_action_pressed("move_left"): dir.x -= 1
    if Input.is_action_pressed("move_right"): dir.x += 1
    if dir != Vector3.ZERO:
        dir = dir.normalized()
    velocity.x = dir.x * speed
    velocity.z = dir.z * speed
    move_and_slide()
