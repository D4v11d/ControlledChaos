class_name GameManager extends Node2D

@onready var quests_button: TextureButton = $"../Player/Camera2D/QuestsButton"
@onready var quest_list: QuestList = $"../Player/Camera2D/QuestList"

# All Quests
@onready var find_npc_quest_1: FindNPCQuest = $"../FindNPCQuest1"

var all_findnpc_quests: Dictionary = {}

func _ready() -> void:
	all_findnpc_quests = {
		find_npc_quest_1.id: find_npc_quest_1
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# The game manager will have access to the npcs and their quests.
# Since the quests are going to be different, we can make a scene for each different quest.
  # - Finding a person and talking to them is a quest, we need the destination person, and put the marker on them
  # - Drive a person somewhere is another type of quest
  # - Finally I'm thinking of a quest about crashing a car, or go to another point without crashing or in
  # a determined time, this is optional. For now there's only 2 types of quest.
  # The completion of the quest will be a function for each different test, the parameters needed are:

# quest 1: npc for giving quest and destination npc.
# quest 2: npc to pickup, (will have pickup area), destination to take the npc to.
func add_quest(quest_id: int):

	if not all_findnpc_quests.has(quest_id):
		print("Error: Quest with ID ", quest_id, " not found in all_findnpc_quests!")
		return
	
	var quest = all_findnpc_quests[quest_id]
	quest_list.add_active_quest(quest.text, quest_id)
	quest.npcToFind.has_quest = true
	quest.npcToFind.quest_icon.visible = true

func complete_quest(quest_id: int):
	quest_list.complete_quest(quest_id)
	var quest = all_findnpc_quests[quest_id]
	quest.npcToFind.has_quest = false
	quest.npcToFind.quest_icon.visible = false


func _on_quests_button_pressed() -> void:
	pass # Replace with function body.
	quests_button.disabled = true
	quest_list.visible = true
