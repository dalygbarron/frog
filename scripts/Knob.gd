class_name Knob
extends Node

signal ended

export(bool) var freeze = false

func activate(arg) -> void:
    pass

func focus() -> void:
    pass

func end(result) -> void:
    emit_signal("ended", result)
