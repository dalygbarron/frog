# Set of helper functionality for creating gui elements.
# To be honest maybe I should just merge this into util.gd

extends Node

export var mod_increment: float = 0.3
onready var small_text = preload("res://knobs/small_text.tscn")
onready var inventory_knob = preload("res://knobs/inventory.tscn")
onready var notice_knob = preload("res://knobs/notice.tscn")

func say(text: String) -> void:
    #yield(display(small_text.instance(), text), "completed")
    pass

func inventory(items: Array) -> Mode:
    var instance = inventory_knob.instance()
    instance.items = items
    return instance

func notice(text: String, options: Array) -> Mode:
    var knob: Mode = notice_knob.instance()
    knob.text = text
    knob.options = options
    return knob

func modulate_children(amount: float) -> void:
    for child in get_children():
            var control := child as Control
            if control:
                control.modulate.r += amount
                control.modulate.g += amount
                control.modulate.b += amount
