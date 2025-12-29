extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_busch = $AnimatedSprite2DBusch
@onready var animated_sprite_prinzessin = $AnimatedSprite2DPrinzessin
@onready var animated_sprite_ritter = $AnimatedSprite2DRitter
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var animated_sprite : AnimatedSprite2D

func set_charakter() -> void:
	print("set_charakter aufgerufen, charakter ist " + str(GlobaleDaten.charakter))
	animated_sprite = animated_sprite_ritter
	match GlobaleDaten.charakter:
		GlobaleDaten.Charakter.Busch:
			animated_sprite = animated_sprite_busch
			animated_sprite_busch.visible = true
			animated_sprite_prinzessin.visible = false
			animated_sprite_ritter.visible = false
			print("Wechsle zu Busch")
		GlobaleDaten.Charakter.Prinzessin:
			animated_sprite = animated_sprite_prinzessin
			animated_sprite_busch.visible = false
			animated_sprite_prinzessin.visible = true
			animated_sprite_ritter.visible = false
			print("Wechsle zu Prinzessin")
		GlobaleDaten.Charakter.Ritter:
			animated_sprite = animated_sprite_ritter
			animated_sprite_busch.visible = false
			animated_sprite_prinzessin.visible = false
			animated_sprite_ritter.visible = true
			print("Wechsle zu Ritter")

func _ready() -> void:
	set_charakter()
	GlobaleDaten.charakter_changed.connect(set_charakter)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var body := collision.get_collider()
			body.apply_central_impulse(-collision.get_normal() * 35)
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	velocity = velocity.slide(collision.get_normal())

func get_bottom_y() -> float:
	# Assumes that the player has a circular collision shape
	return collision_shape.global_position.y + collision_shape.shape.radius
