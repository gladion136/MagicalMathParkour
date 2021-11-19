extends Node


enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

onready var level = get_parent().get_node("Island/Level")
onready var selected_mode = MODE.LINEAR


func _ready():
	pass

func update():
	select_mode(level.current_mode)


func jump(left):
	var a = 0
	var b = 0
	var c = 0
	var d = 0
	match selected_mode:
		MODE.LINEAR:
			a = float($Control/Linear/A.text)
			b = float($Control/Linear/B.text)
		MODE.QUAD:
			a = float($Control/Quad/A.text)
			b = float($Control/Quad/B.text)
			c = float($Control/Quad/C.text)
		MODE.SIN:
			a = float($Control/Sin/A.text)
			b = float($Control/Sin/B.text)
			c = float($Control/Sin/C.text)
			d = float($Control/Sin/D.text)
	
	var player = get_parent().get_node("Island/Player")
	
	# Input check
	match selected_mode:
		MODE.LINEAR:
			get_parent().get_node("FunctionPreview").draw_linear(a, b)
			if player != null:
				player.jump_linear(a, b, left)
		MODE.QUAD:
			get_parent().get_node("FunctionPreview").draw_quad(a, b, c)
			if player != null:
				player.jump_quad(a, b, c, left)
		MODE.SIN:
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
				$Control/ModeSelection.visible = true
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


func _on_TryAgainBtn_pressed():
	get_tree().reload_current_scene()
