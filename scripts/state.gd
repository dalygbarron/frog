extends Node

signal hud_change

var _switches = {}
var _inventory = [
    preload("res://items/crane_hook.tres"),
    preload("res://items/fishing_rod.tres"),
    preload("res://items/crane_key.tres")
]
var _healh = 3
var _max_health = 4
var _mana = 3
var _max_mana = 3
var _money = 1
var _slot_l: Item = null
var _slot_r: Item = null
var _time: float = 0

func set_l(item: Item) -> void:
    _slot_l = item
    emit_signal("hud_change")

func get_l() -> Item:
    return _slot_l

func set_r(item: Item) -> void:
    _slot_r = item
    emit_signal("hud_change")

func get_r() -> Item:
    return _slot_r

func add_item(item: Item) -> void:
    _inventory.append(item)

func get_items(tag) -> Array:
    var items = []
    for item in _inventory:
        if item.tag == tag: items.append(item)
    return items

func get_water_level_at_time(time: float) -> float:
    return sin(time)

func get_water_level():
    return get_water_level_at_time(_time)
