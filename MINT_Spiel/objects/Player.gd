extends KinematicBody2D

const FALL_SPEED = 400
const FLY_SPEED = 400

enum MODE {
	LINEAR,
	QUAD,
	SIN,
}

enum STATE {
	IDLE,
	FLY_UP,
	FLY,
	FALL,
	FREEZE
}

var axis_scale = 0
var current_state = STATE.FALL
var current_mode = MODE.LINEAR
var a = 0
var b = 0
var c = 0
var d = 0
var invert = false
var y_zero = 0 # y pos on zero
var jumps_remaining
var stars_collected = 0
var gui
onready var game = get_tree().current_scene
var camera


func _ready():
	axis_scale = Global.axis_scale
	$AnimationPlayer.play("Idle")
	move_with_coordinate_system(position)


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			pass
		STATE.FLY_UP:
			var target = Vector2(0, y_zero * axis_scale + Global.coordinate_system_center.y - self.position.y)
			if target.length() <= FLY_SPEED/100:
				set_current_state(STATE.FLY)
			else:
				var velocity = target.normalized() * FLY_SPEED * delta
				var collision = move_and_collide(velocity)
				if collision != null:
					if collision.normal.y > 0 or collision.normal.y < 0:
						check_collision_and_set_state(collision, STATE.FALL)
		STATE.FLY:
			_move_with_function(delta)
		STATE.FALL:
			var collision = move_and_collide(Vector2(0,delta*FALL_SPEED))
			if collision != null:
				if collision.normal.y < 0:
					check_collision_and_set_state(collision, STATE.IDLE)


func check_collision_and_set_state(collision, expected_state):
	if collision.collider is TileMap:
		var cell = collision.collider.world_to_map((collision.position - collision.normal)*2)
		var tileId = collision.collider.get_cellv(cell)
		match tileId:
			12: # glibber
				set_current_state(STATE.IDLE)
				print("Hang in glibber")
			13: #spikes
				game.game_over()
				print("Game over by spikes")
			_: # default
				set_current_state(expected_state)
	else:
		set_current_state(expected_state)

"""
	Set current state and update properties to it
"""
func set_current_state(state):
	current_state = state
	match current_state:
		STATE.IDLE:
			camera.follow_player = false
			set_remaining_jumps(jumps_remaining - 1)
			$AnimationPlayer.play("Idle")
			move_coordinate_system(self.position)
			var function_preview = get_tree().get_root().get_node("InGame/FunctionPreview")
			function_preview.current_mode = function_preview.MODE.EMPTY
			function_preview.update()
		STATE.FLY_UP:
			camera.follow_player = true
			gui.set_remaining_jumps_label(jumps_remaining-1)
			$AnimationPlayer.play("Fly")
		STATE.FLY:
			$AnimationPlayer.play("Fly")
		STATE.FALL:
			$AnimationPlayer.play("Fall")
		STATE.FREEZE:
			$AnimationPlayer.stop(false)
		


"""
	Move player with coordinate system together
"""
func move_with_coordinate_system(pos):
	self.position = pos
	move_coordinate_system(pos)


"""
	Move coordinate system and redraw it
"""
func move_coordinate_system(pos):
	Global.coordinate_system_center = pos
	game.on_coordinate_system_changed()


"""
	Start jumping linear
"""
func jump_linear(a, b, left):
	if current_state == STATE.IDLE:
		print("Jump linear")
		self.a = -a
		self.b = -b
		self.y_zero = self.b
		$Sprite.flip_h = left
		invert = left
		current_mode = MODE.LINEAR
		set_current_state(STATE.FLY_UP)


"""
	Start jumping quadratic
"""
func jump_quad(a, b, c, left):
	if current_state == STATE.IDLE:
		print("Jump quad")
		self.a = -a
		self.b = b
		self.c = -c
		self.y_zero = self.a*(self.b)*(self.b) + self.c
		$Sprite.flip_h = left
		invert = left
		current_mode = MODE.QUAD
		set_current_state(STATE.FLY_UP)


"""
	Start jumping sinus
"""
func jump_sin(a, b, c, d, left):
	if current_state == STATE.IDLE:
		print("Jump sin")
		self.a = -a
		self.b = b
		self.c = c
		self.d = -d
		self.y_zero = self.a*sin(self.b*2*PI*self.c)+self.d
		$Sprite.flip_h = left
		invert = left
		current_mode = MODE.SIN
		set_current_state(STATE.FLY_UP)


"""
	Move the player along the current function
"""
func _move_with_function(delta):
	var x_cur = (self.position.x - Global.coordinate_system_center.x) / axis_scale
	var x_next = x_cur
	if invert:
		x_next -= 1.0 * FLY_SPEED / axis_scale * delta
	else:
		x_next += 1.0 * FLY_SPEED / axis_scale * delta
	match current_mode:
		MODE.LINEAR:
			var y = (a*x_next) + b
			var y_n = y * axis_scale + Global.coordinate_system_center.y - 1
			var x_n = x_next * axis_scale + Global.coordinate_system_center.x
			var velocity = Vector2(x_n - self.position.x, y_n - self.position.y).normalized() * FLY_SPEED * delta
			var collision = move_and_collide(velocity)
			if collision:
				check_collision_and_set_state(collision, STATE.FALL)
		MODE.QUAD:
			var y = a*(b+x_next)*(b+x_next) + c
			var y_n = y * axis_scale + Global.coordinate_system_center.y - 1
			var x_n = x_next * axis_scale + Global.coordinate_system_center.x
			var velocity = Vector2(x_n - self.position.x, y_n - self.position.y).normalized() * FLY_SPEED * delta
			var collision = move_and_collide(velocity)
			if collision:
				check_collision_and_set_state(collision, STATE.FALL)
		MODE.SIN:
			var y = a*sin(b*2*PI*(x_next+c))+d
			var y_n = y * axis_scale + Global.coordinate_system_center.y - 1
			var x_n = x_next * axis_scale + Global.coordinate_system_center.x
			var velocity = Vector2(x_n - self.position.x, y_n - self.position.y).normalized() * FLY_SPEED * delta
			var collision = move_and_collide(velocity)
			if collision:
				check_collision_and_set_state(collision, STATE.FALL)

func set_remaining_jumps(jumps):
	jumps_remaining = jumps
	gui.set_remaining_jumps_label(jumps_remaining)
	if jumps <= 0:
		game.game_over()

func star_collected():
	stars_collected += 1
