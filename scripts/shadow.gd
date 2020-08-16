extends Spatial

var margin = Vector3(0, 0.1, 0)
var hidden = false
onready var sprite: Sprite3D = $sprite
onready var ray: RayCast = $ray

func _ready():
    ray.add_exception(get_node(".."))

func _physics_process(delta):
    if ray.is_colliding():
        if hidden:
            hidden = false
            sprite.show()
        var hitPoint = ray.get_collision_point() + margin
        sprite.look_at_from_position(
            hitPoint,
            hitPoint + ray.get_collision_normal(),
            Vector3(0.2, 0.4, 0.3)
        )
    elif not hidden:
        hidden = true
        sprite.hide()
