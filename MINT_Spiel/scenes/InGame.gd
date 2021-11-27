extends Node


func _ready():
	for child in get_node("Island").get_children():
		get_node("Island").remove_child(child)
	var new_level = load("res://level/" + Global.level_res).instance()
	get_node("Island").add_child(new_level)
	new_level.current_mode = Global.mode
	$GUI.level = new_level
	$GUI.update()
	
	# Spawn player
	var player = preload("res://objects/Player.tscn").instance()
	get_node("Island").add_child(player)
	player.gui = $GUI
	player.set_remaining_jumps(new_level.amount_jumps + 1)
	player.move_with_coordinate_system(new_level.get_node("Spawn").position)
	
