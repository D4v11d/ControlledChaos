class_name QuestItem extends TextureRect

@onready var label: Label = $MarginContainer/Label
@onready var pending_quest: TextureRect = $PendingQuest

var quest_text: String = "Default quest"
var quest_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pending_quest.visible = true
	label.text = quest_text
