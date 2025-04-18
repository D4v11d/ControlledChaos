class_name Npc extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var player_detection = $PlayerDetection if has_node("PlayerDetection") else null
@onready var quest_icon: Sprite2D = $QuestIcon

@export var initial_direction: Vector2
@export var speed: float

@export var npc_name: String = ""
@export var quest_id: int
@export var has_quest: bool
@export var is_destination_npc: bool

const STOP_THRESHOLD = 5.0

var current_direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var target_position: Vector2
var is_moving := true

func _ready() -> void:
	if initial_direction:
		current_direction = initial_direction
	update_animation()
	
	if player_detection:
		player_detection.set_npc_name(npc_name)
		
	if has_quest:
		quest_icon.visible = true

func _physics_process(delta: float) -> void:
	if not is_moving:
		velocity = Vector2.ZERO
		return
	
	# Move toward target
	velocity = current_direction * speed
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
