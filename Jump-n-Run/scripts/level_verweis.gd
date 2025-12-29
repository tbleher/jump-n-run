@tool

extends Area2D

## Name des Levels
@export var level_name : String:
	set(value):
		level_name = value
		if not name_node:
			name_node = get_node("Name")
			if name_node:
				name_node.text = value

@export var target_level : PackedScene

var name_node : Label

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if not name_node:
		name_node = get_node("Name")
	name_node.text = level_name


func _on_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint():
		return
		
	if target_level:
		call_deferred("change_scene")

func change_scene() -> void:
	Fade.fade_out(func():
		get_tree().change_scene_to_packed(target_level)
		Fade.fade_in()
	)
