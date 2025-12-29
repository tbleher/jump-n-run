@tool
extends RigidBody2D

enum Farbe {Blau, Grün, Gelb, Lila}
## Farbe der Flasche
@export var farbe : Farbe = Farbe.Blau:
	set(value):
		farbe = value
		update_farbe()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_farbe()

func update_farbe() -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite == null:
		return
	match farbe:
		Farbe.Blau:
			sprite.region_rect.position.x = 0
			sprite.region_rect.position.y = 128
		Farbe.Grün:
			sprite.region_rect.position.x = 0
			sprite.region_rect.position.y = 112
		Farbe.Gelb:
			sprite.region_rect.position.x = 16
			sprite.region_rect.position.y = 112
		Farbe.Lila:
			sprite.region_rect.position.x = 16
			sprite.region_rect.position.y = 128
