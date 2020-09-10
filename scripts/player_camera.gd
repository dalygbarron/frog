class_name PlayerCamera
extends Camera

signal perched

const MIN_ZOOM = 0.5
const MAX_ZOOM = 5.0

export var speed = 4
export var angle_speed = 8
export var offset = Vector3(0, 3, -10)
var angle: float = 0
var target: Cunt = null
var _zoom: float = 1
onready var day_env = preload("res://scenes/parts/day_environment.tscn")
onready var under_env = preload("res://scenes/parts/under_environment.tscn")

func _ready():
    translation = target.translation + offset
    transform = transform.looking_at(target.translation, Vector3(0, 1, 0))
    far = 900.0

func _physics_process(delta):
    var auto = Vector3()
    var direction = Vector3()
    if Input.is_action_pressed("camera_left"):
        angle -= speed * delta
    if Input.is_action_pressed("camera_right"):
        angle += speed * delta
    if Input.is_action_pressed("camera_forward") and _zoom > MIN_ZOOM:
        _zoom -= delta
    if Input.is_action_pressed("camera_back") and _zoom < MAX_ZOOM:
        _zoom += delta
    translation = target.translation + offset.rotated(Vector3(0, 1, 0), angle) * _zoom
    transform = transform.looking_at(target.translation, Vector3(0, 1, 0))
