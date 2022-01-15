# Superclass that represents a thingy on the stack of game modes
extends Node
class_name Mode

signal finish

# Return true if you want to capture the mouse in this mode and false if not.
func capture_mouse() -> bool:
    return false

# Tells if you modes below this one in the stack should be hidden
func opaque() -> bool:
    return false
