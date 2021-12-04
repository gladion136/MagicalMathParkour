extends Camera2D

const DEFAULT_SPEED = 0.05
const MAX_ZOOM = 2
const MIN_ZOOM = 0.5
const ZOOM_DISTANCE = 0.1

var MAX_SPEED = DEFAULT_SPEED
var follow_player = true
var follow_mouse = false
var player


func _process(delta):
	if follow_mouse:
		var dir = (get_global_mouse_position() - position) * MAX_SPEED
		position += dir
	elif follow_player and player != null:
		position = player.position


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			follow_mouse = event.pressed
		elif event.button_index == BUTTON_WHEEL_UP:
			var new_zoom = Vector2(zoom.x - ZOOM_DISTANCE, zoom.y - ZOOM_DISTANCE)
			if new_zoom.x >= MIN_ZOOM and new_zoom.y >= MIN_ZOOM:
				zoom = new_zoom
		elif event.button_index == BUTTON_WHEEL_DOWN:
			var new_zoom = Vector2(zoom.x + ZOOM_DISTANCE, zoom.y + ZOOM_DISTANCE)
			if new_zoom.x <= MAX_ZOOM and new_zoom.y <= MAX_ZOOM:
				zoom = new_zoom

