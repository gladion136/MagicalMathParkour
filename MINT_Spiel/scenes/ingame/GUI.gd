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
	_on_Button_pressed()

func update():
	select_mode(level.current_mode)

func _on_Button_pressed():
	var a = 0
	var b = 0
	var c = 0
	var d = 0
	match selected_mode:
		MODE.LINEAR:
			a = int($Control/Linear/A.text)
			b = int($Control/Linear/B.text)
		MODE.QUAD:
			a = int($Control/Quad/A.text)
			b = int($Control/Quad/B.text)
			c = int($Control/Quad/C.text)
		MODE.SIN:
			a = int($Control/Sin/A.text)
			b = int($Control/Sin/B.text)
			c = int($Control/Sin/C.text)
			d = int($Control/Sin/D.text)
	
	
	
	# Input check
	match selected_mode:
		MODE.LINEAR:
			get_parent().get_node("FunctionPreview").draw_linear(a, b)
		MODE.QUAD:
			get_parent().get_node("FunctionPreview").draw_quad(a, b, c)
		MODE.SIN:
			get_parent().get_node("FunctionPreview").draw_sin(a, b, c, d)
	


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
