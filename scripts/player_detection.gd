class_name PlayerDetection extends Area2D

var npc_name: String
var show_talk_action := false
var can_start_dialog := true

@onready var npc: Npc = $".."
@onready var talk_again_timer: Timer = $"../TalkAgainTimer"

@onready var game_manager: GameManager = $"../../../GameManager"
@onready var player: Player = $"../../../Player"

func _ready() -> void:
	DialogManager.endOfDialog.connect(on_dialog_end)
	
func _physics_process(delta: float) -> void:
	if show_talk_action and can_start_dialog:
		if Input.is_action_just_pressed("action"):
			var lines: Array[String] = [
				"Hello",
				"My Name is: " + npc_name,
				"Nice to meet you"
			]
			can_start_dialog = false
			player.press_e.visible = false
			player.can_move = false
			DialogManager.start_dialog(global_position, lines, self)  # Pass self
			npc.is_moving = false

func _on_body_entered(body: Node2D) -> void:
	print("npc body entered")
	if body is Player and npc.quest_icon.visible:
		show_talk_action = true
		player.press_e.visible = true

func _on_body_exited(body: Node2D) -> void:
	show_talk_action = false
	player.press_e.visible = false

func set_npc_name(name: String) -> void:
	npc_name = name
	
func on_dialog_end(detection: PlayerDetection) -> void:
	if detection != self:  # Only process if this is the correct NPC
		return
	
	player.can_move = true
	talk_again_timer.start()
	
	if npc.has_quest == true and not npc.is_destination_npc:
		print("adding quest")
		game_manager.add_quest(npc.quest_id)
		npc.has_quest = false
		npc.quest_icon.visible = false
		return
		
	if npc.is_destination_npc:
		print("is destination npc")
		game_manager.complete_quest(npc.quest_id)
		npc.has_quest = false
		npc.is_destination_npc = false
		npc.quest_icon.visible = false

func _on_talk_again_timer_timeout() -> void:
	can_start_dialog = true
	npc.is_moving = true
