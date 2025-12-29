extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var label = $Label

func _ready() -> void:
	label.visible = false
	
func _on_body_entered(body):
	animation_player.play("pickup")
	label.visible = true
	Engine.time_scale = 0.5
	print("Level geschafft!")
	timer.start()

func _on_timer_timeout() -> void:
	print("Zurück zur Level-Auswahl")
	Engine.time_scale = 1
	Fade.fade_out(func():
		get_tree().change_scene_to_file("res://scenes/level/level_auswahl.tscn")
		Fade.fade_in()
	)
	
