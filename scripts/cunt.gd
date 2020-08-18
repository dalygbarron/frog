extends KinematicBody

class_name Cunt

enum Behaviour {
    STATIC,
    DOG,
    PLAYER
}

export(Behaviour) var behaviour = Behaviour.STATIC
export var speed = 50
export var jump = 15
export var gravity = -20
export var damping = 0.01
export var downwardGravityMultiplier = 1.8
var velocity = Vector3()
var dustOffset = Vector3()
onready var dust: Particles = $dust

func _ready():
    dustOffset = dust.translation
    remove_child(dust)
    get_node("/root").call_deferred("add_child", dust)

func _physics_process(delta: float):
    # actual physics
    var effectiveGravity = gravity * \
        (1 if velocity.y > 0 else downwardGravityMultiplier)
    velocity.y += delta * effectiveGravity
    var dampEffect = pow(damping, delta)
    velocity.x *= dampEffect
    velocity.z *= dampEffect
    # logic of moving and jumping and shiet
    velocity += logic(delta)
    # turn to look in direction of velocity
    if abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1:
        $model.rotation.y = atan2(velocity.x, velocity.z) - PI / 2
        $model/AnimationPlayer.play("stretch")
    else:
        $model/AnimationPlayer.stop()
    # dust when hitting ground
    var oldY = velocity.y
    velocity = move_and_slide(velocity, Vector3(0, 1, 0))
    if velocity.y - oldY > 1:
        dust.global_transform.origin = global_transform.origin + dustOffset
        dust.emitting = true

func logic(delta) -> Vector3:
    match behaviour:
        Behaviour.STATIC: return staticLogic(delta)
        Behaviour.DOG: return dogLogic(delta)
        Behaviour.PLAYER: return playerLogic(delta)
    return Vector3()

func staticLogic(delta: float) -> Vector3:
    return Vector3()

func dogLogic(delta: float) -> Vector3:
    return Vector3()

func playerLogic(delta: float) -> Vector3:
    var camera = get_viewport().get_camera()
    if not camera: return Vector3()
    var direction = Vector3()
    var jumpPower = 0
    var cameraTransform = camera.get_global_transform()
    if Input.is_action_pressed("left"):
        direction -= cameraTransform.basis[0] * Input.get_action_strength("left")
    if Input.is_action_pressed("right"):
        direction += cameraTransform.basis[0] * Input.get_action_strength("right")
    if Input.is_action_pressed("forward"):
        direction -= cameraTransform.basis[2] * Input.get_action_strength("forward")
    if Input.is_action_pressed("back"):
        direction += cameraTransform.basis[2] * Input.get_action_strength("back")
    if Input.is_action_pressed("jump") and is_on_floor():
        jumpPower = jump
    # movement
    direction.y = 0
    direction = direction.normalized() * speed * delta
    direction.y = jumpPower
    return direction
