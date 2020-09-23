class_name Fellow
extends KinematicBody2D

const GRAVITY := 445.0
const LOW_GRAVITY := 315.0
const UP := Vector2(0, -1)

export(float) var speed := 1500.0
export(float) var speed_jump := -5.0
export(float) var damp := 0.0001
export(float) var jump := -250.0
var velocity := Vector2()

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    velocity.x *= pow(damp, delta)
    if Input.is_action_pressed("jump") and is_on_floor():
            velocity.y = jump + abs(velocity.x) / speed_jump
    var gravity_power = LOW_GRAVITY if Input.is_action_pressed("jump") and velocity.y < 0 else GRAVITY
    velocity.y += gravity_power * delta
    if Input.is_action_pressed("left"): velocity.x += -speed * delta
    if Input.is_action_pressed("right"): velocity.x += speed * delta
    velocity = move_and_slide(velocity, UP)

