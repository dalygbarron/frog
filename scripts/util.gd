extends Node

const LINE_HOLDER = "B!R!E!X!I!T!"
var line_catcher = RegEx.new()
var held_catcher = RegEx.new()
var white_catcher = RegEx.new()

func _ready():
    line_catcher.compile("\\n\\n+")
    held_catcher.compile(LINE_HOLDER)
    white_catcher.compile("\\s\\s+")

func strip(text: String) -> String:
    text = line_catcher.sub(text, LINE_HOLDER, true)
    text = white_catcher.sub(text, " ", true)
    return held_catcher.sub(text, "\n", true)

func make_button() -> Button:
    var button: Button = Button.new()
    button.mouse_filter = Control.MOUSE_FILTER_IGNORE
    return button
