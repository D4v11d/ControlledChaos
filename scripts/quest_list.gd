class_name QuestList extends Control

var completed_quests: Array[QuestItem] = []
var active_quests: Array[QuestItem] = []

@onready var quest_container: VBoxContainer = $NinePatchRect/ScrollContainer/VBoxContainer
@onready var quests_button: TextureButton = $"../QuestsButton"
@onready var quest_list: QuestList = $"."

var quest_item_scene = preload("res://scenes/quest_item.tscn")

func _ready() -> void:
	add_active_quest("Find your car and drive it", 0)
	add_active_quest("Look around for people with ! mark", 1)

func add_active_quest(quest_text: String, quest_id: int) -> void:
	if not quest_item_scene:
		print("Error: QuestItem scene not set!")
		return
	
	# Avoid adding duplicated quests
	var quest_already_exists = false
	for quest in active_quests:
		if quest.quest_id == quest_id:
			quest_already_exists = true
	
	if quest_already_exists:
		return
	
	var new_quest: QuestItem = quest_item_scene.instantiate()
	new_quest.quest_text = quest_text
	new_quest.quest_id = quest_id
	active_quests.append(new_quest)
	
	if quest_container:
		quest_container.add_child(new_quest)

# For now this just deletes the quest from the array
func complete_quest(quest_id: int) -> void:
	print("completing quest ")
	for quest in active_quests:
		if quest.quest_id == quest_id:
			active_quests.erase(quest)
			
			if quest_container and quest.is_inside_tree():
				quest.queue_free()
			return

func _on_close_button_pressed() -> void:
	quest_list.visible = false
	quests_button.visible = true
	
	for quest in active_quests:
		quest.pending_quest.visible = false
