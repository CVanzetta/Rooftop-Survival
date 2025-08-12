extends Node

func _ready() -> void:
    # Attendre que la scène soit complètement chargée
    await get_tree().process_frame
    
    # Trouver le Player et le spawn point
    var player: CharacterBody3D = get_node("../Player")
    var world: Node3D = get_node("../World")
    
    if player and world:
        var roof_scene: Node3D = world.get_node("RoofScene")
        if roof_scene:
            var spawn_point: Marker3D = roof_scene.get_node("PlayerSpawn")
            if spawn_point:
                player.global_position = spawn_point.global_position
