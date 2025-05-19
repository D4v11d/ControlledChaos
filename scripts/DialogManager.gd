extends Node

@onready var text_box_scene = preload("res://scenes/dialog_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

var current_detection: PlayerDetection  # Store the PlayerDetection instance

signal endOfDialog(detection: PlayerDetection)

func start_dialog(position: Vector2, lines: Array[String], detection: PlayerDetection = null):
	if is_dialog_active:
		return

	dialog_lines = lines
	text_box_position = position

	if detection:
		current_detection = detection

	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():
	print("calling show text box")
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("action") && is_dialog_active) && can_advance_line:
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			endOfDialog.emit(current_detection)  # Emit with stored detection
			current_detection = null  # Clear to prevent accidental reuse
			return
			
		_show_text_box()
