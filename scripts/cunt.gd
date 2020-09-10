class_name Cunt
extends KinematicBody

signal gone

enum Status {
    ACTIVE,
    STATIC,
    GOING
}

const LOOK_STEP = 0.05
const ACTIVATE_METHOD = "activate"

export var verb = "Speak"
export var speed: float = 50
export var jump: float = 15
export var gravity: float = -20
export var damping: float = 0.01
export var downward_gravity_multiplier: float = 1.8
export(String, FILE, "*.wav") var voice_file
var status = Status.ACTIVE
var velocity := Vector3()
var angle = 0
var _dust_offset := Vector3()
var _voice: AudioStream
var _going: Vector3
onready var _dust: Particles = $dust
onready var _animation: AnimationPlayer = $animation

func _ready() -> void:
    if voice_file: _voice = load(voice_file)
    if _dust:
        _dust_offset = _dust.translation
        remove_child(_dust)
        get_tree().get_root().call_deferred("add_child", _dust)

func _physics_process(delta: float) -> void:
    # actual physics
    var effective_gravity: float = gravity * \
        (1 if velocity.y > 0 else downward_gravity_multiplier)
    velocity.y += delta * effective_gravity
    var damp_effect = pow(damping, delta)
    velocity.x *= damp_effect
    velocity.z *= damp_effect
    # logic of moving and jumping and shiet
    velocity += _logic(delta)
    # turn to look in direction of velocity unless there is a look location
    handle_velocity(velocity)
    # dust when hitting ground
    var oldY = velocity.y
    velocity = move_and_slide(velocity, Vector3(0, 1, 0))
    if velocity.y - oldY > 1 and _dust:
        _dust.global_transform.origin = global_transform.origin + _dust_offset
        _dust.emitting = true

func handle_velocity(velocity: Vector3) -> void:
    if abs(velocity.x) >= 0.01 or abs(velocity.z) >= 0.01:
        rotation.y = atan2(velocity.x, velocity.z) - PI / 2
        if _animation: _animation.play("walk")

func active_logic(delta: float) -> Vector3:
    return Vector3()

func static_logic(delta: float) -> Vector3:
    return Vector3()

func going_logic(delta: float) -> Vector3:
    var bird_going = Vector2(_going.x, _going.z)
    var bird_pos = bird_pos()
    var diff = (bird_going - bird_pos).normalized() * speed
    var present_speed = Vector2(velocity.x, velocity.z).length()
    if present_speed * delta > bird_going.distance_to(bird_pos):
        status = Status.STATIC
        emit_signal("gone")
        velocity.x = 0
        velocity.z = 0
        return Vector3()
    return Vector3(diff.x, 0, diff.y)

func voice() -> void:
    if not _voice: return
    $sound.stream = _voice
    $sound.play()

func look(at: Vector3, time: float) -> void:
    var global_pos = global_transform.origin
    var start = rotation.y
    var delta = Util.short_angle(
        start,
        bird_pos().angle_to_point(Vector2(at.z, at.x)) + PI / 2
    )
    var n = floor(time / LOOK_STEP)
    for i in range(n):
        rotation.y = start + (delta / (time / LOOK_STEP)) * i
        yield(Util.wait(LOOK_STEP), "completed")
    if n != time / LOOK_STEP:
        yield(Util.wait(time - n * LOOK_STEP), "completed")
    rotation.y = start + delta

func walk_to(location: Vector3) -> void:
    status = Status.GOING
    _going = location
    yield(self, "gone")

func bird_pos() -> Vector2:
    return Vector2(global_transform.origin.x, global_transform.origin.z)

func _logic(delta: float) -> Vector3:
    match status:
        Status.ACTIVE: return active_logic(delta)
        Status.STATIC: return static_logic(delta)
        Status.GOING: return going_logic(delta)
    return Vector3()
