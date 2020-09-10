class_name HoldableButton
extends Button

var _holdable: Holdable

func _init(holdable: Holdable):
    _holdable = holdable
    icon = holdable.get_icon()

func get_holdable() -> Holdable:
    return _holdable
