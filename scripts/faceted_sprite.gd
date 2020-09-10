class_name FacetedSprite
extends Sprite3D

export var animation_frame: int = 0

func _process(delta: float) -> void:
    var camera = get_viewport().get_camera()
    var pos = global_transform.origin
    var camera_pos = camera.global_transform.origin
    var rot = global_transform.basis.get_euler().y
    var seen_angle = fposmod(atan2(camera_pos.x - pos.x, camera_pos.z - pos.z) - rot,  PI * 2)
    var base_frame = 0
    if seen_angle <= PI / 2.0:
        flip_h = false
        base_frame = 0
    elif seen_angle <= PI:
        flip_h = true
        base_frame = 0
    elif seen_angle <= PI * 4 / 3:
        flip_h = true
        base_frame = hframes / 2.0
    else:
        flip_h = false
        base_frame = hframes / 2.0
    frame = base_frame + animation_frame
