class_name FacetedSprite
extends Sprite3D

export var animation_frame: int = 0

func _process(delta: float) -> void:
    var camera := get_viewport().get_camera()
    var pos := global_transform.origin
    var camera_pos := camera.global_transform.origin
    var rot := global_transform.basis.get_euler().y
    var seen_angle := fposmod(atan2(camera_pos.x - pos.x, camera_pos.z - pos.z) - rot,  PI * 2)
    var base_frame: int = 0
    if seen_angle > PI / 4 * 7:
        base_frame = hframes * 2
    elif seen_angle > PI / 4 * 5:
        base_frame = hframes * 3
    elif seen_angle > PI / 4 * 3:
        base_frame = hframes
    elif seen_angle > PI / 4:
        base_frame = 0
    else:
        base_frame = hframes * 2
    frame = base_frame + animation_frame
