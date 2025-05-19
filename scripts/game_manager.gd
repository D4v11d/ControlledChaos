class_name GameManager extends Node2D

@onready var player: Player = $"../Player"
@onready var player_car: CarMovement = $"../PlayerCar"

@onready var quests_button: TextureButton = $"../CanvasLayer/HBoxContainer/MarginContainer/QuestsButton"
@onready var quest_list: QuestList = $"../CanvasLayer/HBoxContainer/MarginContainer/QuestList"
@onready var pending_quest: Sprite2D = $"../CanvasLayer/HBoxContainer/MarginContainer/QuestsButton/PendingQuest"
@onready var respawn_button: TextureButton = $"../CanvasLayer/HBoxContainer/MarginContainer2/RespawnButton"

# All Quests
@onready var drive_car_quest: FindNPCQuest = $"../FindNPCQuests/DriveCarQuest"
@onready var initial_quest: FindNPCQuest = $"../FindNPCQuests/InitialQuest"

# Find npc quests
@onready var lost_in_the_park: FindNPCQuest = $"../FindNPCQuests/LostInThePark"
@onready var near_orange_trees: FindNPCQuest = $"../FindNPCQuests/NearOrangeTrees"
@onready var fruit_sell: FindNPCQuest = $"../FindNPCQuests/FruitSell"

# taxi quests
@onready var taxi_quest_1: TaxiQuest = $"../TaxiQuests/Quest1"
@onready var taxi_quest_2: TaxiQuest = $"../TaxiQuests/Quest2"
@onready var taxi_quest_3: TaxiQuest = $"../TaxiQuests/Quest3"

# All quests completed
@onready var congratulations: FindNPCQuest = $"../FindNPCQuests/Congratulations!"


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var respawn_point: Area2D = $"../RespawnPoint"
@onready var car_respawn_point: Area2D = $"../CarRespawnPoint"

var completed_quests := 0

var all_quests: Dictionary = {}

func _ready() -> void:
	all_quests = {
		# special quests
		drive_car_quest.id: drive_car_quest, # special quest 1 -> drive car
		initial_quest.id: initial_quest, # special quest 2 -> talk to npc with ! marker
		# find npc quests
		lost_in_the_park.id: lost_in_the_park,
		near_orange_trees.id: near_orange_trees,
		fruit_sell.id: fruit_sell,
		# taxi quests
		taxi_quest_1.id: taxi_quest_1,
		taxi_quest_2.id: taxi_quest_2,
		taxi_quest_3.id: taxi_quest_3,
		
		congratulations.id: congratulations
	}

func add_quest(quest_id: int):

	if not all_quests.has(quest_id):
		print("Error: Quest with ID ", quest_id, " not found in all_quests!")
		return
	
	var quest = all_quests[quest_id]
	quest_list.add_active_quest(quest.text, quest_id)
	
	# case: is FindNPCQuest
	if quest is FindNPCQuest:
		if quest.npcToFind:
			quest.npcToFind.has_quest = true
			quest.npcToFind.quest_icon.visible = true
	
	pending_quest.visible = true

func complete_quest(quest_id: int):
	quest_list.complete_quest(quest_id)
	var quest = all_quests[quest_id]
	++completed_quests
	
	if quest is FindNPCQuest:
		if quest.npcToFind:
			quest.npcToFind.has_quest = false
			quest.npcToFind.quest_icon.visible = false
	
	if completed_quests >= 5:
		add_quest(-1)


func _on_quests_button_pressed() -> void:
	quests_button.visible = false
	quest_list.visible = true
	
	pending_quest.visible = false


func respawn_player() -> void:
	player.global_position = respawn_point.global_position


func respawn_car() -> void:
	player_car.global_position = car_respawn_point.global_position


func _on_respawn_button_pressed() -> void:
	respawn_player()
	respawn_car()
