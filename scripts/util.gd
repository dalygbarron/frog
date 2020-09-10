extends Node

const LINE_HOLDER = "B!R!E!X!I!T!"
var line_catcher = RegEx.new()
var held_catcher = RegEx.new()
var white_catcher = RegEx.new()
var timers = []

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

func wait(time: float) -> void:
    var timer: Timer = null
    if timers.empty():
        timer = Timer.new()
        add_child(timer)
    else:
        timer = timers.pop_front()
    timer.wait_time = time
    timer.start()
    yield(timer, "timeout")

func short_angle(from, to):
    var max_angle = PI * 2
    var delta = fmod(to - from, max_angle)
    return fmod(2 * delta, max_angle) - delta
