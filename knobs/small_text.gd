extends Mode

func activate(arg) -> void:
    assert(typeof(arg) == TYPE_STRING)
    $vbox/text.text = Util.strip(arg)
    $vbox/text.anchor_right = 1
    $vbox/text.autowrap = true
    yield($vbox/button, "pressed")

func focus() -> void:
    $vbox/button.grab_focus()
