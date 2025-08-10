extends Node
class_name Crafting

var recipes := []
@onready var inventory: Inventory = get_node("../Inventory")

func _ready() -> void:
    var f := FileAccess.open("res://data/recipes.json", FileAccess.READ)
    if f:
        var j: Variant = JSON.parse_string(f.get_as_text())
        recipes = j.get("recipes", [])

func craft(id: String) -> bool:
    var r: Array = recipes.filter(func(x): return x.id == id)
    if r.size() == 0: return false
    var recipe: Variant = r[0]
    for k in recipe.in.keys():
        if !inventory.has(k, int(recipe.in[k])): return false
    for k in recipe.in.keys():
        inventory.remove(k, int(recipe.in[k]))
    for k in recipe.out.keys():
        inventory.add(k, int(recipe.out[k]))
    return true
