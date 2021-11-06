extends Node2D

func _ready():
	for child in get_node("Island").get_children():
		get_node("Island").remove_child(child)
	var new_level = load("res://level/" + Global.level_res).instance()
	get_node("Island").add_child(new_level)
	new_level.current_mode = Global.mode
	$GUI.level = new_level	
	$GUI.update()

