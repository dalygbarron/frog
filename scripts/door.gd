class_name Door
extends Cunt

onready var animation = $animation
var end: Spatial

func _ready() -> void:
    end = get_node("end")

func active_logic(delta: float) -> Vector3:
    velocity = Vector3()
    return velocity

func static_logic(delta: float) -> Vector3:
    velocity = Vector3()
    return velocity

func look(at: Vector3, time: float) -> void:
    yield(Util.wait(time), "completed")

func activate(player: Player, item: Item) -> void:
    if item:
        yield(
            Gui.say("%s does nothing here" % item.get_display_name()),
            "completed"
        )
    else:
        $animation.play("open")
        yield($animation, "animation_finished")
        $shape.disabled = true
        var target = global_transform.origin
        if end: target = end.global_transform.origin
        yield(player.walk_to(end.global_transform.origin), "completed")
        $animation.play("close")
        yield($animation, "animation_finished")
