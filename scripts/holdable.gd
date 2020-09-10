class_name Holdable
extends Node

enum Tag {
    MAIN,
    TAPE,
    ESKY
}

func get_display_name() -> String:
    return "???"

func get_technical_name() -> String:
    return ""

func get_tag():
    return Tag.MAIN

func get_icon() -> Texture:
    return null

func get_description() -> String:
    return "description"

func get_active() -> bool:
    return false

func get_verb() -> String:
    return "Use now"
