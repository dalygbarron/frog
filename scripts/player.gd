class_name Player
extends Cunt

signal interact

export var look_length = 3
export var look_angle = PI / 3
export var sneak_length = 12
var close = []
var closest: Cunt = null
var _sneaking = false
onready var eyes: Rope = $eyes
const FRONT: Vector3 = Vector3(1, 0, 0)

func _ready() -> void:
    eyes.hide()

func _input(event):
    if event.is_action_pressed("sneak") and closest:
        _sneaking = true

func handle_velocity(velocity: Vector3) -> void:
    .handle_velocity(velocity)
    if _sneaking:
        var closest_pos = closest.global_transform.origin
        rotation.y = bird_pos().angle_to_point(
            Vector2(closest_pos.z, closest_pos.x)
        ) + PI / 2

func active_logic(delta: float) -> Vector3:
    print(velocity)
    var camera = get_viewport().get_camera()
    var direction = Vector3()
    var jumpPower = 0
    var cameraTrans: Transform = camera.global_transform
    if Input.is_action_pressed("left"):
        direction -= cameraTrans.basis[0] * Input.get_action_strength("left")
    if Input.is_action_pressed("right"):
        direction += cameraTrans.basis[0] * Input.get_action_strength("right")
    if Input.is_action_pressed("forward"):
        direction -= cameraTrans.basis[2] * Input.get_action_strength("forward")
    if Input.is_action_pressed("back"):
        direction += cameraTrans.basis[2] * Input.get_action_strength("back")
    if Input.is_action_pressed("jump") and is_on_floor():
        jumpPower = jump
        $up.play()
    if _sneaking and (not Input.is_action_pressed("sneak") or global_transform.origin.distance_to(closest.global_transform.origin) > sneak_length):
        _sneaking = false
        _reevaluate()
    # Interacting with other cunts
    if is_on_floor():
        if Input.is_action_just_pressed("x"):
            emit_signal("interact", closest, null)
        elif Input.is_action_just_pressed("b") and State.get_b():
            emit_signal("interact", closest, State.get_b())
        elif Input.is_action_just_pressed("y") and State.get_y():
            emit_signal("interact", closest, State.get_y())
        elif Input.is_action_just_pressed("left_shoulder") and State.get_l():
            emit_signal("interact", closest, State.get_l())
        elif Input.is_action_just_pressed("right_shoulder") and State.get_r():
            emit_signal("interact", closest, State.get_r())
    # movement
    direction.y = 0
    direction = direction.normalized() * speed
    direction.y = jumpPower
    print(direction)
    return direction

func interacting_logic(delta: float) -> Vector3:
    return Vector3()

func use_holdable(holdable: Holdable) -> void:
    # TODO: I think we are gonna need something like a stack or a semaphore here
    #       if it starts failing because it's not reentrant
    if holdable.get_active():
        status = Cunt.Status.STATIC
        yield(Config.use(self, holdable), "completed")
        status = Cunt.Status.ACTIVE
    else:
        status = Cunt.Status.STATIC
        yield(
            Gui.say("%s\n%s" % [holdable.get_display_name(), holdable.get_description()]),
            "completed"
        )
        status = Cunt.Status.ACTIVE

func hit(body: PhysicsBody) -> void:
    var cunt := body as Cunt
    if not cunt or cunt == self: return
    close.append(cunt)
    if not _sneaking and status == Cunt.Status.ACTIVE: _reevaluate()

func leave(body: PhysicsBody) -> void:
    var cunt := body as Cunt
    if not cunt or cunt == self: return
    close.remove(close.find(cunt))
    if not _sneaking and status == Cunt.Status.ACTIVE: _reevaluate()

func _reevaluate() -> void:
    var oldClosest = closest
    var distance = 99999
    var found = false
    for item in close:
        var contestant := item as Cunt
        if contestant == closest:
            found = true
            continue
        var contestantDistance = contestant.global_transform.origin.distance_to(
            global_transform.origin
        )
        if contestantDistance < distance:
            distance = contestantDistance
            closest = contestant
            found = true
    if not found: closest = null
    if closest != oldClosest:
        if closest:
            eyes.show()
            eyes.target = closest.global_transform.origin
        else:
            eyes.hide()
