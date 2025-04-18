class_name QuestList extends MarginContainer

var completed_quests: Array[QuestItem] = []
var active_quests: Array[QuestItem] = []

@export var quest_item_scene: PackedScene
@onready var quest_container: VBoxContainer = $VBoxContainer

func add_active_quest(quest_text: String) -> void:
	if not quest_item_scene:
		print("Error: QuestItem scene not set!")
		return
	
	var new_quest: QuestItem = quest_item_scene.instantiate()
	
	new_quest.quest_text = quest_text
	
	active_quests.append(new_quest)
	
	if quest_container:
		quest_container.add_child(new_quest)
