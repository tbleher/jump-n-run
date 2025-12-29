extends Node

var score = 0

@onready var score_label = $CanvasLayer/ScoreLabel

func _ready() -> void:
	score_label.text = "0 Münzen"
	
func add_point():
	score += 1
	if score == 1:
		score_label.text = str(score) + " Münze"
	else:
		score_label.text = str(score) + " Münzen"
