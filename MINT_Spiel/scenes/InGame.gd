extends Node

onready var point_scene = preload("res://objects/point.tscn")

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
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var new_point = point_scene.instance()
			$Island.add_child(new_point)
			new_point.position = get_node("Island/Level/TileMap").get_global_mouse_position()
			print("Spawn point: " + str(new_point.position))
