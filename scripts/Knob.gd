extends Node

class_name Knob

signal ended

func activate(arg) -> void:
    pass

func focus() -> void:
    pass

func end(result) -> void:
    emit_signal("ended", result)
