class_name PlayerDetection extends Area2D

var npc_name: String
var show_talk_action := false
var can_start_dialog := true
var has_pending_quest := false

@onready var npc: Npc = $".."
@onready var talk_again_timer: Timer = $"../TalkAgainTimer"
@onready var quest_icon: Sprite2D = $"../QuestIcon"

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
			DialogManager.start_dialog(global_position, lines)
			npc.is_moving = false
	

func _on_body_entered(body: Node2D) -> void:
	print("npc body entered")
	show_talk_action = true

func _on_body_exited(body: Node2D) -> void:
	show_talk_action = false

func set_npc_name(name: String) -> void:
	npc_name = name
	
func on_dialog_end():
	talk_again_timer.start()
	
func _on_talk_again_timer_timeout() -> void:
	can_start_dialog = true
	npc.is_moving = true
