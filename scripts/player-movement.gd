class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

const SPEED = 75.0

var last_direction := Vector2.DOWN

func _ready() -> void:
	animated_sprite_2d.play("standing-front")

func _physics_process(delta: float) -> void:
	handle_move()
	
func handle_move() -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		if velocity == Vector2.ZERO:  # Just stopped moving
			play_standing_animation()
	
	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			animated_sprite_2d.play("walk-back")
			last_direction = Vector2.UP
		else:
			animated_sprite_2d.play("walk-front")
			last_direction = Vector2.DOWN
	else:
		if direction.x != 0:
			animated_sprite_2d.play("walk-side")
			animated_sprite_2d.flip_h = direction.x < 0
			last_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT

func play_standing_animation() -> void:
	if last_direction == Vector2.UP:
		animated_sprite_2d.play("standing-back")
	elif last_direction == Vector2.DOWN:
		animated_sprite_2d.play("standing-front")
	else:
		animated_sprite_2d.play("standing-side")
		animated_sprite_2d.flip_h = last_direction == Vector2.LEFT
