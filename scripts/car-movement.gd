class_name CarMovement extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var player: Player = $"../Player"
@onready var camera_2d: Camera2D = $"../Player/Camera2D"

@export var is_player_car = false

const MAX_SPEED = 200.0
const ACCELERATION = 300.0 
const DECELERATION = 400.0 

var last_direction := Vector2.DOWN
var current_speed := 0.0
var is_player_driving := false
var can_drive_car := false

func _ready() -> void:
	animated_sprite_2d.play("standing-front")
	if not player or not camera_2d:
		push_warning("Player or Camera2D not found!")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and can_drive_car and not is_player_driving:
		enter_car()
	elif Input.is_action_just_pressed("action") and is_player_driving:
		exit_car()
	
	if is_player_driving:
		handle_move(delta)

func enter_car() -> void:
	if not player or not camera_2d:
		return
	
	is_player_driving = true
	
	# Reparent Camera2D to Car
	camera_2d.reparent(self)
	camera_2d.global_position = global_position
	camera_2d.enabled = true
	
	# Disable Player
	player.set_physics_process(false)
	player.collision_layer = 0
	player.collision_mask = 0
	player.visible = false
	player.global_position = global_position

func exit_car() -> void:
	if not player or not camera_2d:
		return
	
	is_player_driving = false
	
	# Reparent Camera2D back to Player
	camera_2d.reparent(player)
	camera_2d.global_position = player.global_position
	camera_2d.enabled = true
	
	# Re-enable Player
	player.set_physics_process(true)
	
	# 3 = Layers 1 and 2 apparently
	player.collision_layer = 3 
	player.collision_mask = 3
	player.visible = true
	player.global_position = Vector2(global_position.x, global_position.y + 5)
	
	# Reset car state
	current_speed = 0.0
	velocity = Vector2.ZERO

func handle_move(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if direction != Vector2.ZERO:
		current_speed = min(current_speed + ACCELERATION * delta, MAX_SPEED)
		velocity = direction * current_speed
		update_animation(direction)
	else:
		current_speed = max(current_speed - DECELERATION * delta, 0.0)
		velocity = last_direction * current_speed
		if current_speed == 0.0:
			velocity = Vector2.ZERO
	
	move_and_slide()

func update_animation(direction: Vector2) -> void:
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

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player and is_player_car:
		can_drive_car = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body is Player and is_player_car:
		can_drive_car = false
