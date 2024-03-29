extends Node

onready var point_scene = preload("res://objects/point.tscn")
var player
var new_level
var max_jumps

func _ready():
	for child in get_node("Island").get_children():
		get_node("Island").remove_child(child)
	new_level = load("res://level/" + Global.level_res).instance()
	get_node("Island").add_child(new_level)
	$GUI.level = new_level
	$GUI.update()
	$FunctionPreview.init_coordinate_system()
	
	# Spawn player
	player = preload("res://objects/Player.tscn").instance()
	get_node("Island").add_child(player)
	player.gui = $GUI
	
	player.set_remaining_jumps(new_level.amount_jumps + 1)
	player.move_with_coordinate_system(new_level.get_node("Spawn").position)
	get_node("Island/Level/Camera2D").player = player
	player.camera = get_node("Island/Level/Camera2D")
	$GUI.set_star_count(player.stars_collected, new_level.star_count)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var new_point = point_scene.instance()
			$Island.add_child(new_point)
			new_point.position = get_node("Island").get_global_mouse_position()
			print("Spawn point: " + str(new_point.position))


func game_over():
	$GUI.on_game_over()


func game_finished():
	var stats = { 	"level_res" : Global.level_res,
					"used_jumps" : str(new_level.amount_jumps - player.jumps_remaining + 1),
					"max_jumps" : str(new_level.amount_jumps),
					"total_stars" : str(new_level.star_count),
					"stars_collected" : str(player.stars_collected)}
	$GUI.on_finish_game(stats)
	player.set_current_state(player.STATE.FREEZE)
	Global.save_stats(stats)


func on_coordinate_system_changed():
	$FunctionPreview.set_new_pos(Global.coordinate_system_center)


func add_star():
	player.star_collected()
	$GUI.set_star_count(player.stars_collected, new_level.star_count)
