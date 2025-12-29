extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Ritter ausgewählt")
	GlobaleDaten.set_charakter(GlobaleDaten.Charakter.Ritter)
