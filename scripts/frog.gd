extends KinematicBody

export var speed = 12
export var jump = 15
export var gravity = -20
export var downwardGravityMultiplier = 1.8
var velocity = Vector3()
var dustOffset = Vector3()
onready var camera: Camera = get_node("/root/root/camera")
onready var dust: Particles = get_node("dust")

func _ready():
    dustOffset = dust.translation
    remove_child(dust)
    get_node("/root").call_deferred("add_child", dust)

func _physics_process(delta):
    # user input
    var direction = Vector3()
    var cameraTransform = camera.get_global_transform()
    if Input.is_action_pressed("left"):
        direction -= cameraTransform.basis[0] * Input.get_action_strength("left")
    if Input.is_action_pressed("right"):
        direction += cameraTransform.basis[0] * Input.get_action_strength("right")
    if Input.is_action_pressed("forward"):
        direction -= cameraTransform.basis[2] * Input.get_action_strength("forward")
    if Input.is_action_pressed("back"):
        direction += cameraTransform.basis[2] * Input.get_action_strength("back")
    if (Input.is_action_pressed("jump") and is_on_floor()):
        velocity.y += jump
    # movement
    direction.y = 0
    direction = direction.normalized() * speed
    var effectiveGravity = gravity * \
        (1 if velocity.y > 0 else downwardGravityMultiplier)
    velocity.y += delta * effectiveGravity
    velocity.x = direction.x
    velocity.z = direction.z
    var oldY = velocity.y
    velocity = move_and_slide(velocity, Vector3(0, 1, 0))
    if velocity.y - oldY > 1:
        dust.global_transform.origin = global_transform.origin + dustOffset
        dust.emitting = true

