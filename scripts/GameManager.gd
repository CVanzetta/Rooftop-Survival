extends Node

@export var player_scene: PackedScene = preload("res://scenes/Player.tscn")
@export var roof_scene: PackedScene = preload("res://scenes/world/Roof.tscn")

func _ready() -> void:
    # Instancier le toit
    var roof: Node3D = roof_scene.instantiate()
    add_child(roof)
    
    # Trouver le spawn point et instancier le player
    var spawn_point: Node3D = roof.get_node("SpawnPoint")
    if spawn_point and player_scene:
        var player: CharacterBody3D = player_scene.instantiate()
        add_child(player)
        player.global_position = spawn_point.global_position
