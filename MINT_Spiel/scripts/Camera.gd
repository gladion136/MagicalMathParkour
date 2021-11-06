extends Camera2D

const DEFAULT_SPEED = 200

var MAX_SPEED = DEFAULT_SPEED
var follow_player = false


func _ready():
	pass


func _physics_process(delta):
	if follow_player:
		pass # follow player
	else:
		# Determine velocity
		var _velocity = Vector2.ZERO
		_velocity += get_input_vector()
		var _velocity_with_speed = (_velocity * MAX_SPEED * delta).round()
		position += _velocity_with_speed


func get_input_vector():
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("camera_right") - \
			Input.get_action_strength("camera_left")
	dir.y = Input.get_action_strength("camera_down") - \
			Input.get_action_strength("camera_up")
	return dir

	
