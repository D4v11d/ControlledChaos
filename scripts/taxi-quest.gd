class_name TaxiQuest extends Node2D

@export var npc_to_pick_up: Npc
@export var text: String
@export var id: int

@onready var player_car: CarMovement = $"../../PlayerCar"
@onready var pickup_area: Area2D = $PickupArea
@onready var place_to_go: Area2D = $PlaceToGo

@onready var game_manager: GameManager = $"../../GameManager"

var is_player_in_pickup_area: bool = false
var is_player_in_dropoff_area: bool = false

func _ready() -> void:
	pickup_area.body_entered.connect(_on_pickup_area_body_entered)
	pickup_area.body_exited.connect(_on_pickup_area_body_exited)
	
	place_to_go.body_entered.connect(_on_place_to_go_body_entered)
	place_to_go.body_exited.connect(_on_place_to_go_body_exited)

func _process(_delta: float) -> void:
	# Pick up passenger
	if Input.is_action_just_pressed("action") and is_player_in_pickup_area:
		game_manager.add_quest(id)
		DialogManager.start_dialog(global_position, npc_to_pick_up.taxi_dialog_lines)
		
		# Pick up passenger
		npc_to_pick_up.has_quest = false
		npc_to_pick_up.quest_icon.visible = false
		npc_to_pick_up.visible = false
		pickup_area.queue_free()
		
		# Activate drop off area
		place_to_go.visible = true
		place_to_go.collision_layer = 8
		place_to_go.collision_mask = 8
	
	# Drop off
	if Input.is_action_just_pressed("action") and is_player_in_dropoff_area:
		if id == 12:
			npc_to_pick_up.global_position = Vector2(player_car.global_position.x, player_car.global_position.y - 25)
		else:
			npc_to_pick_up.global_position = Vector2(player_car.global_position.x, player_car.global_position.y + 25)
		npc_to_pick_up.visible = true
		DialogManager.start_dialog(npc_to_pick_up.global_position, ["Thanks!"])
		game_manager.complete_quest(id)
		place_to_go.queue_free()

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is CarMovement:
		is_player_in_pickup_area = true
		player_car.pickup.visible = true
		player_car.pickup.get_child(0).visible = true

func _on_pickup_area_body_exited(body: Node2D) -> void:
	if body is CarMovement:
		is_player_in_pickup_area = false
		player_car.pickup.visible = false
		player_car.pickup.get_child(0).visible = false

func _on_place_to_go_body_entered(body: Node2D) -> void:
	if body is CarMovement:
		is_player_in_dropoff_area = true
		player_car.dropoff.visible = true
		player_car.dropoff.get_child(0).visible = true

func _on_place_to_go_body_exited(body: Node2D) -> void:
	if body is CarMovement:
		is_player_in_dropoff_area = false
		player_car.dropoff.visible = false
		player_car.dropoff.get_child(0).visible = false
