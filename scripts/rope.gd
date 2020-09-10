class_name Rope
extends Spatial

export(Texture) var texture
export(float) var n_nodes = 4
export(float) var pixel_size = 0.03125
var target := Vector3()
var _start: float = 0

func _ready():
    for i in range(n_nodes):
        var node := Sprite3D.new()
        node.texture = texture
        node.billboard = SpatialMaterial.BILLBOARD_ENABLED
        node.pixel_size = pixel_size
        node.shaded = false
        node.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
        add_child(node)

func _process(delta: float) -> void:
    _start += delta
    if _start >= 1: _start -= 1
    var i = _start
    var inc = (target -  global_transform.origin) / n_nodes
    for child in get_children():
        child.global_transform.origin = global_transform.origin + inc * i
        i += 1
