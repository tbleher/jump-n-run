extends Node

enum Charakter {Ritter,Prinzessin,Busch}

signal charakter_changed

var charakter : Charakter = Charakter.Ritter

func set_charakter(value : Charakter) -> void:
	charakter = value
	print("Emit character_changed")
	charakter_changed.emit()

func _ready() -> void:
	if OS.get_name() != "Linux" and OS.get_name() != "Windows":
		var controls = preload("res://scenes/mobile_controls.tscn").instantiate()
		add_child(controls)
