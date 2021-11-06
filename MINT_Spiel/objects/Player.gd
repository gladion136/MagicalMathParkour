extends KinematicBody2D

const axis_scale = 503
const FALL_SPEED = 400
const FLY_SPEED = 6

enum MODE {
	LINEAR,
	QUAD,
	SIN,
}

enum STATE {
	IDLE,
	FLY,
	FALL
}

var current_state = STATE.FALL
var coordinate_system_center = Vector2.ZERO
var current_mode = MODE.LINEAR
var a = 0
var b = 0
var c = 0
var d = 0
var x = 0
var invert = false

func _ready():
	$AnimationPlayer.play("Idle")
	coordinate_system_center = position


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			pass
		STATE.FLY:
			_move_with_function(delta)
		STATE.FALL:
			if not _better_move(Vector2(0,delta*FALL_SPEED)):
				set_current_state(STATE.IDLE)


func set_current_state(state):
	current_state = state
	match current_state:
		STATE.IDLE:
			$AnimationPlayer.play("Idle")
			move_coordinate_system(self.position)
			var function_preview = get_tree().get_root().get_node("InGame/FunctionPreview")
			function_preview.current_mode = function_preview.MODE.EMPTY
			function_preview.update()
		STATE.FLY:
			$AnimationPlayer.play("Fly")
		STATE.FALL:
			$AnimationPlayer.play("Fall")

func move_with_coordinate_system(pos):
	self.position = pos
	move_coordinate_system(pos)


func move_coordinate_system(pos):
	print("Move system")
	coordinate_system_center = pos
	# redraw
	get_tree().get_root().get_node("InGame/FunctionPreview").coordinate_system_center = pos
	get_tree().get_root().get_node("InGame/FunctionPreview").update()


func jump_linear(a, b, left):
	x = 0
	self.a = a
	self.b = b
	if invert != left:
		$Sprite.flip_h = not $Sprite.flip_h
	invert = left
	current_mode = MODE.LINEAR
	set_current_state(STATE.FLY)
	$AnimationPlayer.play("Jump")


func jump_quad(a, b, c, left):
	x = 0
	self.a = a
	self.b = b
	self.c = c
	if invert != left:
		$Sprite.flip_h = not $Sprite.flip_h
	invert = left
	current_mode = MODE.QUAD
	set_current_state(STATE.FLY)
	$AnimationPlayer.play("Jump")


func jump_sin(a, b, c, d, left):
	x = 0
	self.a = a
	self.b = b
	self.c = c
	self.d = d
	if invert != left:
		$Sprite.flip_h = not $Sprite.flip_h
		invert = left
	current_mode = MODE.SIN
	set_current_state(STATE.FLY)
	$AnimationPlayer.play("Jump")


func _move_with_function(delta):
	var x_cur = (self.position.x - coordinate_system_center.x) / axis_scale
	var x_next = x_cur
	if invert:
		x_next -= 3 * delta
	else:
		x_next += 3 * delta
	match current_mode:
		MODE.LINEAR:
			var y_n = -(a*x_next) * axis_scale + -b * axis_scale/10 + coordinate_system_center.y
			var x_n = (coordinate_system_center.x+x_next*axis_scale)
			print(Vector2(x_n,y_n))
			var velocity = Vector2(x_n - self.position.x, y_n - self.position.y).normalized() * FLY_SPEED
			print(velocity)
			if not _better_move(velocity):
				$AnimationPlayer.play("Idle")
				set_current_state(STATE.FALL)
		MODE.QUAD:
			pass
#				var x = float(i-coordinate_system_center.x+b)/(get_viewport_rect().size.x/axis_scale)*3
#				var x_1 = float(i-coordinate_system_center.x+1+b)/(get_viewport_rect().size.x/axis_scale)*3
#				var y = (a*(x)*(x)+c+coordinate_system_center.y)
#				var y_1 = (a*(x_1)*(x_1)+c+coordinate_system_center.y)
#				draw_line(Vector2(i, y), Vector2(i+1, y_1), ColorN("slateblue"), 2)
				#draw_line(Vector2(i, a*(((i-margin_left)+b)*((i-margin_left)+b))+margin_top), Vector2((i+1), a*(((i-margin_left+1)+b)*((i-margin_left+1)+b)+1)+margin_top), ColorN("slateblue"), 1)
		MODE.SIN:
			pass
#			for i in range(get_viewport_rect().size.x):
#				draw_line(Vector2(i, a*sin(b*2*PI*(i+coordinate_system_center.x)+c)+d+coordinate_system_center.y), Vector2((i+0.5), a*sin(b*2*PI*(i-coordinate_system_center.x+0.5)+c)+d+coordinate_system_center.y), ColorN("slateblue"), 2)


"""
	Move the player along the given velocity. WARNING: Function changes self.position
	Input: Vector2
	Return: Not collided? (boolean)
"""
func _better_move(_velocity: Vector2):
	var _velocity_x = Vector2(_velocity.x, 0)
	var _velocity_y = Vector2(0, _velocity.y)

	if _velocity == Vector2.ZERO:
		return true

	var _vel_collide = move_and_collide(_velocity, true, true, true)
	if not _vel_collide:
		self.position += _velocity
		return true

	var _vel_y_collide = move_and_collide(_velocity_y, true, true, true)
	if not _vel_y_collide:
		self.position += _velocity_y

	var _vel_x_collide = move_and_collide(_velocity_x, true, true, true)
	if not _vel_x_collide:
		self.position += _velocity_x
	return false

