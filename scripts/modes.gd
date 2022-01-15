# Yeah so in this file we are defining the singleton that manages the stack
extends Node

signal reveal

var _modes := []

func _ready():
    var tree := get_tree()
    tree.paused = true
    var mode = tree.current_scene as Mode
    if mode: push(mode)
    else: push_error("Game is not starting with a mode you fool")

func _pop(arg, mode: Mode) -> void:
    get_tree().root.remove_child(mode)
    _modes.erase(mode)
    if not _modes.empty():
        _modes.back().pause_mode = PAUSE_MODE_PROCESS
        _update_mouse()
    else:
        get_tree().quit()        

func _update_mouse():
    if _modes.empty(): return
    var mouse_mode := Input.MOUSE_MODE_VISIBLE
    if _modes.back().capture_mouse(): mouse_mode = Input.MOUSE_MODE_CAPTURED
    Input.set_mouse_mode(mouse_mode)
    
# Adds a mode to the stack of modes
func push(mode: Mode) -> Mode:
    mode.pause_mode = PAUSE_MODE_PROCESS
    if not _modes.empty(): _modes.back().pause_mode = PAUSE_MODE_STOP
    mode.connect("finish", self, "_pop", [mode])
    _modes.append(mode)
    get_tree().root.add_child(mode)
    _update_mouse()
    return mode

# Replaces the current top mode with a different one asynchronously later
func replace(mode: Mode) -> Mode:
    _update_mouse()
    return mode
