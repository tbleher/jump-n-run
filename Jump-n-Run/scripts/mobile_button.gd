extends Button

@export var action_name: String

var active_touch_id := -1

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event):
	# Touch pressed
	if event is InputEventScreenTouch:
		if event.pressed and active_touch_id == -1:
			active_touch_id = event.index
			Input.action_press(action_name)

		elif not event.pressed and event.index == active_touch_id:
			active_touch_id = -1
			Input.action_release(action_name)

	# Mouse fallback (editor / desktop)
	elif event is InputEventMouseButton:
		if event.pressed:
			Input.action_press(action_name)
		else:
			Input.action_release(action_name)
