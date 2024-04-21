extends Node

@onready var dialog_box_scene = preload("res://prefabs/dialog_box.tscn")
var message_lines : Array[String] = []
var current_line = 0

var dialog_box
var dialog_box_position := Vector2.ZERO

var is_massage_active := false
var can_advance_massage := false

func start_massage(position: Vector2, lines: Array[String]):
	if is_massage_active:
		return
	
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_massage_active = true
	
func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_display)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advance_massage = false
	
func _on_all_text_display():
	can_advance_massage = true
	
func _unhandled_input(event):
	if (event.is_action_pressed("advance_massage") && is_massage_active && can_advance_massage):
		dialog_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size():
			is_massage_active = false
			current_line = 0
			return
		show_text()
