extends Area2D



func _on_body_entered(body: Node2D) -> void:
	print("Prinzessin ausgewählt")
	GlobaleDaten.set_charakter(GlobaleDaten.Charakter.Prinzessin)
