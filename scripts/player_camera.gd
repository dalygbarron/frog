class_name PlayerCamera
extends Camera

signal perched

const MIN_ZOOM = 0.5
const MAX_ZOOM = 5.0
const ROTATE_STEP = 0.03
const ROTATE_SPEED = 5

export var speed = 4
export var angle_speed = 8
export var offset = Vector3(0, 6, -10)
var angle: float = 0
var target: Cunt = null
var _rotate_lock := false
var _rotate := 0.0
onready var day_env = preload("res://scenes/parts/day_environment.tscn")
onready var under_env = preload("res://scenes/parts/under_environment.tscn")

func _ready():
    translation = target.translation + offset
    transform = transform.looking_at(target.translation, Vector3(0, 1, 0))
    far = 900.0

func _process(delta: float) -> void:
    if not _rotate_lock:
        if Input.is_action_just_pressed("camera_left"):
            _rotate = angle - PI / 2
            _rotate_lock = true
        if Input.is_action_just_pressed("camera_right"):
            _rotate = angle + PI / 2
            _rotate_lock = true
        if Input.is_action_just_pressed("camera_back") or Input.is_action_just_pressed("camera_forward"):
            _rotate = angle + PI
            _rotate_lock = true
    else:
        var diff = _rotate - angle
        if abs(diff) < ROTATE_SPEED * delta:
            angle = _rotate
            _rotate_lock = false
        else:
            angle += sign(diff) * ROTATE_SPEED * delta
    translation = target.translation + offset.rotated(Vector3(0, 1, 0), angle)
    transform = transform.looking_at(target.translation, Vector3(0, 1, 0))
