@tool
extends AnimatableBody2D

const TARGET_NAME := "Zielposition"

var target_offset := Vector2(100, 0)
# Used only if the marker does not yet exist

var target: Marker2D

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

## Geschwindigkeit der Plattform
@export var geschwindigkeit := 30.0
## Wartezeit in Sekunden an der Start- und Zielposition
@export var wartezeit := 0

var start_position : Vector2
var target_position : Vector2
var going_to_target := true
var wait_timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_farbe()
	update_breite()
	ensure_marker()
	start_position = global_position
	if not Engine.is_editor_hint():
		target_position = target.global_position
		# Hide marker during gameplay
		if target:
			target.visible = false

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
			if cshape.shape.size.x != 32:
				var shape = cshape.get_shape().duplicate()
				shape.size.x = 32
				cshape.set_shape(shape)
		Breite.SCHMAL:
			sprite.region_rect.position.x = 0
			sprite.region_rect.size.x = 16
			if cshape.shape.size.x != 16:
				var shape = cshape.get_shape().duplicate()
				shape.size.x = 16
				cshape.set_shape(shape)

func _physics_process(delta) -> void:
	if Engine.is_editor_hint():
		if target and target_offset != target.position:
			target_offset = target.position
			queue_redraw()
		return
	
	if wait_timer > 0.0:
		wait_timer -= delta
		return

	var destination = target_position if going_to_target else start_position
	global_position = global_position.move_toward(destination, geschwindigkeit * delta)

	if global_position.distance_to(destination) < 1.0:
		going_to_target = !going_to_target
		wait_timer = wartezeit

func ensure_marker():
	if has_node(TARGET_NAME):
		target = get_node(TARGET_NAME)
		return

	# Create marker automatically
	target = Marker2D.new()
	target.name = TARGET_NAME
	target.position = target_offset
	add_child(target)

	target.owner = get_owner() if get_owner() else self

	# Make it clearly visible in editor
	target.gizmo_extents = 16
	target.visible = true

func is_editable() -> bool:
	if not Engine.is_editor_hint():
		return false
	var parent = get_parent()
	if parent == null:
		return false
	return parent.is_editable_instance(self)
	
func _enter_tree():
	if is_editable():
		ensure_marker()
		lock_children_except_marker()

func lock_children_except_marker() -> void:
	for child in get_children():
		if child == target:
			child.set_meta("_edit_lock_", true)
		else:
			child.set_meta("_edit_lock_", false)

func _draw():
	if is_editable() and target:
		draw_line(Vector2.ZERO, target.position, Color.YELLOW, 2)
		
func _get_configuration_warnings() -> PackedStringArray:
	if not Engine.is_editor_hint():
		return []

	if not is_editable():
		return [
			"Bitte aktiviere 'Bearbeitbare Child-Objekte' via Rechts-Klick, um die Zielposition einzustellen."
		]

	return []
