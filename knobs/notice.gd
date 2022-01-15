extends Mode

var text: String
var options: Array

func _ready():
    $vbox/text.text = Util.strip(text)
    $vbox/text.anchor_right = 1
    $vbox/text.autowrap = true
    for i in range(options.size()):
        var text := options[i] as String
        if not text: continue
        var button := Button.new()
        button.text = text
        button.connect("pressed", self, "click", [i])
        $vbox.add_child(button)
    $anim.play("enter")

func click(index: int) -> void:
    $anim.play("exit")
    yield($anim, "animation_finished")
    emit_signal("finish", index)
