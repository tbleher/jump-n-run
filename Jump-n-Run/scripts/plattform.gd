@tool
extends AnimatableBody2D

enum Farbe {GRÜN, BRAUN, GELB, BLAU}
## Farbe der Plattform
@export var farbe : Farbe = Farbe.GRÜN:
	set(value):
		farbe = value
		update_farbe()
		
enum Breite {BREIT, SCHMAL}
## Breite der Plattform
@export var breite : Breite = Breite.BREIT:
	set(value):
		breite = value
		update_breite()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_farbe()
	update_breite()
	
func update_farbe() -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite == null:
		return
	match farbe:
		Farbe.GRÜN:
			sprite.region_rect.position.y = 0
		Farbe.BRAUN:
			sprite.region_rect.position.y = 16
		Farbe.GELB:
			sprite.region_rect.position.y = 32
		Farbe.BLAU:
			sprite.region_rect.position.y = 48

func update_breite() -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite == null:
		return
	var cshape := get_node_or_null("CollisionShape2D")
	if cshape == null:
		return
	match breite:
		Breite.BREIT:
			sprite.region_rect.position.x = 16
			sprite.region_rect.size.x = 32
			var shape = cshape.get_shape().duplicate()
			shape.size.x = 32
			cshape.set_shape(shape)
		Breite.SCHMAL:
			sprite.region_rect.position.x = 0
			sprite.region_rect.size.x = 16
			var shape = cshape.get_shape().duplicate()
			shape.size.x = 16
			cshape.set_shape(shape)
