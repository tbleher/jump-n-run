extends CanvasLayer

@export var fade_time := 0.5

@onready var rect := $ColorRect
var tween: Tween


func fade_out(callback: Callable) -> void:
	_kill_tween()
	rect.visible = true
	rect.modulate.a = 0.0

	tween = create_tween()
	tween.tween_property(
		rect,
		"modulate:a",
		1.0,
		fade_time
	)
	tween.finished.connect(callback)


func fade_in() -> void:
	_kill_tween()
	rect.modulate.a = 1.0
	rect.visible = true

	tween = create_tween()
	tween.tween_property(
		rect, "modulate:a", 0.0, fade_time
	)
	tween.finished.connect(func():
		rect.visible = false
	)


func _kill_tween():
	if tween and tween.is_running():
		tween.kill()
