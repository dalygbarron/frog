extends Node

signal hud_change

var _switches = {}
var _inventory = []
var _healh = 3
var _max_health = 4
var _mana = 3
var _max_mana = 3
var _money = 1
var _slot_b: Holdable = null
var _slot_y: Holdable = null
var _slot_l: Holdable = null
var _slot_r: Holdable = null
var _time: float = 0
var _x_message = null

func set_b(holdable: Holdable) -> void:
    _slot_b = holdable
    emit_signal("hud_change")

func get_b() -> Holdable:
    return _slot_b

func set_y(holdable: Holdable) -> void:
    _slot_y = holdable
    emit_signal("hud_change")

func get_y() -> Holdable:
    return _slot_y

func set_l(holdable: Holdable) -> void:
    _slot_l = holdable
    emit_signal("hud_change")

func get_l() -> Holdable:
    return _slot_l

func set_r(holdable: Holdable) -> void:
    _slot_r = holdable
    emit_signal("hud_change")

func get_r() -> Holdable:
    return _slot_r

func set_x_message(message):
    _x_message = message

func get_x_message():
    return _x_message

func add_holdable(holdable: Holdable) -> void:
    _inventory.append(holdable)

func get_holdables(tag) -> Array:
    var items = []
    for holdable in _inventory:
        if holdable.get_tag() == tag: items.append(holdable)
    return items

func get_water_level_at_time(time: float) -> float:
    return sin(time)

func get_water_level():
    return get_water_level_at_time(_time)
