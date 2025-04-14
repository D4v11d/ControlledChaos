class_name CarNpc extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var initial_direction: Vector2

const SPEED = 100.0
const STOP_THRESHOLD = 5.0     # Stop when this close to target

var current_direction := Vector2.RIGHT
var last_direction := Vector2.RIGHT
var target_position: Vector2
var is_moving := true

func _ready() -> void:
	if initial_direction:
		current_direction = initial_direction
	update_animation()

func _physics_process(delta: float) -> void:
	if not is_moving:
		velocity = Vector2.ZERO
		return
	
	# Move toward target
	velocity = current_direction * SPEED
	update_animation()
	move_and_collide(velocity * delta)
	
func update_animation() -> void:
	var direction = current_direction
	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			animated_sprite_2d.play("move-up")
			last_direction = Vector2.UP
		else:
			animated_sprite_2d.play("move-down")
			last_direction = Vector2.DOWN
	else:
		if direction.x != 0:
			animated_sprite_2d.play("move-right")
			animated_sprite_2d.flip_h = direction.x < 0
			last_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
