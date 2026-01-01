extends Node2D

@onready var links : RayCast2D = $RayCast2DLinksUnten
@onready var rechts : RayCast2D = $RayCast2DRechtsUnten
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

## Geschwindigkeit in Pixeln
@export var geschwindigkeit : float = 40

var richtung : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if richtung == -1 and not links.is_colliding():
		richtung = 1
		print("links keine Kollision")
		sprite.play("rennen_rechts")
	elif richtung == 1 and not rechts.is_colliding():
		richtung = -1
		sprite.play("rennen_links")
		print("rechts keine Kollision")

func _process(delta: float) -> void:
	position.x += richtung * geschwindigkeit * delta
