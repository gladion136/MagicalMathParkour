extends Node


enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

onready var level = get_parent().get_node("Island/Level")
onready var selected_mode = MODE.LINEAR

var valid_characters = ['0','1','2','3','4','5','6','7','8','9','0','.','/','-']

func _ready():
	$LevelName.text = Global.level_name
	for child in $Control.get_children():
		for node in child.get_children():
			if node.is_class("LineEdit"):
				node.connect("text_changed", self, "restrict_input", [node])

func update():
	select_mode(Global.mode)


func jump(left):
	var a = 0
	var b = 0
	var c = 0
	var d = 0
	match selected_mode:
		MODE.LINEAR:
			a = self.parse_input($Control/Linear/A.text)
			b = self.parse_input($Control/Linear/B.text)
		MODE.QUAD:
			a = self.parse_input($Control/Quad/A.text)
			b = self.parse_input($Control/Quad/B.text)
			c = self.parse_input($Control/Quad/C.text)
		MODE.SIN:
			a = self.parse_input($Control/Sin/A.text)
			b = self.parse_input($Control/Sin/B.text)
			c = self.parse_input($Control/Sin/C.text)
			d = self.parse_input($Control/Sin/D.text)
			
	var player = get_parent().get_node("Island/Player")
	
	# Input check
	match selected_mode:
		MODE.LINEAR:
			if a == null:
				# do something to hint that the Input is wrong
				$Control/Linear/A.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if b == null:
				# do something to hint that the Input is wrong
				$Control/Linear/B.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if a == null or b == null:
				$Control/WrongInputMsgLbl.visible = true
				# do nothing (don't jump)
				return
			get_parent().get_node("FunctionPreview").draw_linear(a, b)
			if player != null:
				player.jump_linear(a, b, left)
		MODE.QUAD:
			if a == null:
				# do something to hint that the Input is wrong
				$Control/Quad/A.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if b == null:
				# do something to hint that the Input is wrong
				$Control/Quad/B.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if c == null:
				# do something to hint that the Input is wrong
				$Control/Quad/C.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if a == null or b == null or c == null:
				$Control/WrongInputMsgLbl.visible = true
				# do nothing (don't jump)
				return
			get_parent().get_node("FunctionPreview").draw_quad(a, b, c)
			if player != null:
				player.jump_quad(a, b, c, left)
		MODE.SIN:
			if a == null:
				# do something to hint that the Input is wrong
				$Control/Sin/A.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if b == null:
				# do something to hint that the Input is wrong
				$Control/Sin/B.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if c == null:
				# do something to hint that the Input is wrong
				$Control/Sin/C.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if d == null:
				# do something to hint that the Input is wrong
				$Control/Sin/D.modulate = ColorN('red')
				# color gets reset in restrict_input() after any change to the text
			if a == null or b == null or c == null or d == null:
				$Control/WrongInputMsgLbl.visible = true
				# do nothing (don't jump)
				return
			get_parent().get_node("FunctionPreview").draw_sin(a, b, c, d)
			if player != null:
				player.jump_sin(a, b, c, d, left)


func _on_BtnLinear_pressed():
	select_mode(MODE.LINEAR)


func _on_BtnQuad_pressed():
	select_mode(MODE.QUAD)


func _on_BtnSin_pressed():
	select_mode(MODE.SIN)


func select_mode(mode):
	if mode != selected_mode:
		match selected_mode:
			MODE.LINEAR:
				$Control/Linear.visible = false
			MODE.QUAD:
				$Control/Quad.visible = false
			MODE.SIN:
				$Control/Sin.visible = false
		selected_mode = mode
		
		match selected_mode:
			MODE.LINEAR:
				$Control/Linear.visible = true
			MODE.QUAD:
				$Control/Quad.visible = true
			MODE.SIN:
				$Control/Sin.visible = true
			MODE.MULTI:
				$ModeSelection.visible = true
		selected_mode = mode


func _on_BtnBack_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_BtnJumpL_pressed():
	jump(true)


func _on_BtnJumpR_pressed():
	jump(false)
	
func set_remaining_jumps_label(remaining_jumps):
	$JumpsRemainig.text = "Sprünge übrig: " + str(remaining_jumps)

func on_game_over():
	$GameOverScreen.visible = true

func on_finish_game(stats):
	$FinishScreen/Stats.text = "Du hast "+ stats["used_jumps"] +" / "+ stats["max_jumps"] +" Versuchen gebraucht."
	$FinishScreen.visible = true
	$FinishScreen/StarNode2.set_star_count(stats["stars_collected"], stats["total_stars"])

func _on_TryAgainBtn_pressed():
	get_tree().reload_current_scene()

"""
deletes all non valid characters that were entered without changing
the cursor position
"""
func restrict_input(text, lineEdit):
	var i = 0
	var cursor_position = lineEdit.get_cursor_position()
	var deleted_before_cursor = 0
	while(i < len(text)):
		if not (text[i] in valid_characters):
			if i < cursor_position:
				deleted_before_cursor += 1
			text[i] = ''
		else:
			i += 1
	lineEdit.text = text
	lineEdit.set_cursor_position(cursor_position-deleted_before_cursor)
	lineEdit.modulate = Color(1,1,1,1)
	$Control/WrongInputMsgLbl.visible = false

"""
parses the input of a lineEdit and returns the float value or null if the input
is invalid
"""
func parse_input(input_text):
	var le = len(input_text)
	if le == 0:
		return null
	if input_text[0] == '/':
		return null
	if input_text[le-1] == '/':
		return null
	if input_text[le-1] == '-':
		return null
	var slash = false
	for i in range(0, le):
		if i >= 1:
			if input_text[i] == '/':
				if slash == true:
					return null
				else:
					slash = true
			if input_text[i] == '/' and input_text[i-1] == '-':
				return null
			if input_text[i] == '-' and input_text[i-1] != '/':
				return null
		if i < le - 1:
			if input_text[i] == '.' and input_text[i+1] in "./-":
				return null
	if slash:
		var slash_pos = input_text.find('/')
		var denominator = float(input_text.substr(slash_pos+1, le-(slash_pos+1)))
		if denominator != 0:
			var numerator = float(input_text.substr(0, slash_pos))
			return numerator / denominator
		else:
			return null
	return float(input_text)
