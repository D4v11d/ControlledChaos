class_name CornerArea extends Area2D

@export var possible_directions: Array[Vector2] = [] 

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func get_direction() -> Vector2:
	if possible_directions.size() == 0:
		push_warning("CornerArea has no directions set!")
		return Vector2.ZERO
	elif possible_directions.size() == 1:
		return possible_directions[0]
	else:
		return possible_directions[randi() % possible_directions.size()]


func _on_body_entered(body: Node2D) -> void:
	if body is Npc:
		var npc = body as Npc
		var new_direction = get_direction()
		if new_direction != Vector2.ZERO:
			npc.current_direction = new_direction
			npc.update_animation()
