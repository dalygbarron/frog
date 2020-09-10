extends Control

export var mod_increment: float = 0.3
onready var small_text = preload("res://knobs/small_text.tscn")
onready var inventory_knob = preload("res://knobs/inventory.tscn")
onready var notice_knob = preload("res://knobs/notice.tscn")

func _ready() -> void:
    pause_mode = PAUSE_MODE_PROCESS

func display(knob: Knob, argument) -> Object:
    modulate_children(-mod_increment)
    add_child(knob)
    get_tree().paused = knob.freeze
    knob.activate(argument)
    knob.focus()
    var result =  yield(knob, "ended")
    remove_child(knob)
    knob.queue_free()
    var n_children = get_child_count()
    if n_children == 0:
        get_tree().paused = false
    else:
        modulate_children(mod_increment)
        var child := get_child(n_children - 1) as Knob
        if child:
            child.focus()
            get_tree().paused = child.freeze
    return result

func say(text: String) -> void:
    yield(display(small_text.instance(), text), "completed")

func inventory(items: Array) -> Item:
    return yield(display(inventory_knob.instance(), items), "completed")

func notice(text: String, options: Array) -> int:
    var args = {"text": text, "options": options}
    return yield(display(notice_knob.instance(), args), "completed")

func modulate_children(amount: float) -> void:
    for child in get_children():
            var control := child as Control
            if control:
                control.modulate.r += amount
                control.modulate.g += amount
                control.modulate.b += amount
