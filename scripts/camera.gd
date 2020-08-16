extends Camera

export var distanceMargin = 0.2
export var distance = 8
export var heightRatio = 2.5
export var speed = 20
export var autoSpeed = 6
var target: Spatial = null
var zoom = 1

func _ready():
    target = get_node("/root/root/cunt")
    translation = target.translation + \
        Vector3(0, distance / heightRatio, distance)
    look(target)

func _physics_process(delta):
    if not target: return
    var auto = Vector3()
    var direction = Vector3()
    if Input.is_action_pressed("camera_left"):
        direction -= transform.basis[0]
    if Input.is_action_pressed("camera_right"):
        direction += transform.basis[0]
    if Input.is_action_just_pressed("camera_forward"):
        zoom /= 1.5
    if Input.is_action_just_pressed("camera_back"):
        zoom *= 1.5
    direction.y = 0
    direction = direction.normalized()
    var meTop = Vector2(translation.x, translation.z)
    var targetTop = Vector2(target.translation.x, target.translation.z)
    var currentDistance = meTop.distance_to(targetTop)
    var realDistance = distance * zoom
    var realHeight = distance / heightRatio * zoom
    if currentDistance > realDistance + distanceMargin:
        auto -= transform.basis[2]
    if currentDistance < realDistance - distanceMargin:
        auto += transform.basis[2]
    if translation.y < target.translation.y + realHeight - distanceMargin:
        auto.y += 1
    if translation.y > target.translation.y + realHeight + distanceMargin:
        auto.y -= 1
    auto = auto.normalized()
    translation += direction * speed * delta + auto * autoSpeed * delta
    look(target)

func look(at: Spatial):
    transform = transform.looking_at(at.translation, Vector3(0, 1, 0))

