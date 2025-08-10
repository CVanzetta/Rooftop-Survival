extends Node
class_name Inventory

var items := {"scrap": 20, "plastic": 8, "charcoal": 4, "textile": 6}

func has(item: String, qty: int) -> bool:
    return items.get(item, 0) >= qty

func add(item: String, qty: int) -> void:
    items[item] = items.get(item, 0) + qty

func remove(item: String, qty: int) -> bool:
    if !has(item, qty): return false
    items[item] -= qty
    return true
