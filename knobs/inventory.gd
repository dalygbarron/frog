extends Mode

var _last_button = 0
var items := []

func _ready():
    for i in items:
        var button = Button.new()
        button.icon = i.icon
        button.button_mask = BUTTON_MASK_LEFT | BUTTON_MASK_RIGHT
        if i.usage == Item.Usage.NONE: button.disabled = true
        button.hint_tooltip = i.display_name
        button.connect("pressed", self, "_on_item_pressed", [i])
        button.connect("gui_input", self, "_on_click")
        $panel/vbox/hbox/panel/grid.add_child(button)
    var l = State.get_l() as Item
    var r = State.get_r() as Item
    if l: $panel/vbox/hbox/vbox/buttons/l.texture = l.icon
    if r: $panel/vbox/hbox/vbox/buttons/r.texture = r.icon

func _on_quit_pressed():
    $anim.play("exit")
    yield($anim, "animation_finished")
    emit_signal("finish", null)

func _on_click(event):
    if event is InputEventMouseButton: _last_button = event.button_index

func _on_item_pressed(item: Item):
    match (_last_button):
        BUTTON_LEFT:
            State.set_l(item)
            $panel/vbox/hbox/vbox/buttons/l.texture = item.icon
        BUTTON_RIGHT:
            State.set_r(item)
            $panel/vbox/hbox/vbox/buttons/r.texture = item.icon
