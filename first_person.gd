class_name Player
extends KinematicBody

const JUMP := 12.3
const GRAVITY := 30.0
const MOUSE_SENSITIVITY := 0.02
const SPEED := 10.0

var velocity := Vector3()

func _process(delta):
    if $camera/ray.is_colliding():
        print($camera/ray.get_collider())

func _physics_process(delta):
    if (Input.is_action_pressed("ui_accept") and is_on_floor()):
        velocity.y = JUMP
    velocity.y -= GRAVITY * delta
    var desired_velocity = get_input() * SPEED
    velocity.x = desired_velocity.x
    velocity.z = desired_velocity.z
    velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation.y += -event.relative.x * MOUSE_SENSITIVITY
        $camera.rotation.x += -event.relative.y * MOUSE_SENSITIVITY
        $camera.rotation.x = clamp($camera.rotation.x, -1.2, 1.2)

func get_input():
    var input_dir = Vector3()
    if Input.is_action_pressed("move_forward"):
        input_dir += -global_transform.basis.z
    if Input.is_action_pressed("move_backward"):
        input_dir += global_transform.basis.z
    if Input.is_action_pressed("strafe_left"):
        input_dir += -global_transform.basis.x
    if Input.is_action_pressed("strafe_right"):
        input_dir += global_transform.basis.x
    input_dir = input_dir.normalized()
    return input_dir
