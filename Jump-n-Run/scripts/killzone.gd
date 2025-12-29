extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body is CharacterBody2D:
		var enemy := get_parent()
		if enemy.is_in_group("killable_enemy"):
			var enemy_collision_shape := get_node_or_null("CollisionShape2D")
			print("killable enemy: own pos " + str(body.global_position) + " enemy pos:" + str(enemy.global_position))
			print("bottom y: "+ str(body.get_bottom_y()) + " enemy_center: " + str(enemy_collision_shape.global_position.y))
			if body.get_bottom_y() < enemy_collision_shape.global_position.y:
				print("Enemy dies")
				enemy.queue_free()
				return
		print("You died!")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	if body is RigidBody2D:
		body.queue_free()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
