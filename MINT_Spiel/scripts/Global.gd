extends Node

enum MODE {
	LINEAR,
	QUAD
	SIN,
	MULTI
}

const COORDINATE_SYSTEM_PIXEL_SIZE = 30000

var level_res = ""
var level_name = ""
var mode = MODE.LINEAR
var axis_scale = 150
var COORDINATE_SYSTEM_SIZE = COORDINATE_SYSTEM_PIXEL_SIZE / axis_scale


const axis_label_length = 10
const stroke_width = 20

# stores levels of current mode
var current_level_list = []

var coordinate_system_center = Vector2.ZERO


var game_data = {"levels":[]}

func _ready():
	load_game_data()


func get_stats(level_res):
	for level in game_data["levels"]:
		if level_res == level["level_res"]:
			return level
	return null


func save_stats(stats):
	var is_saved = false
	var is_added = false
	for level in game_data["levels"]:
		if level.level_res == stats.level_res:
			is_saved = true
			if level.stars_collected < stats.stars_collected:
				replace_stats(level, stats)
			elif level.stars_collected <= stats.stars_collected and level.used_jumps > stats.used_jumps:
				replace_stats(level, stats)
	if not is_saved:
		game_data["levels"].append(stats)
	save_game_data(game_data)


func replace_stats(old_stats, new_stats):
	game_data["levels"].remove(game_data["levels"].find(old_stats))
	game_data["levels"].append(new_stats)


func save_game_data(data):
	var save_game = File.new()
	save_game.open("user://game_data.save", File.WRITE)
	save_game.store_line(to_json(game_data))
	save_game.close()


func load_game_data():
	var filename = "user://game_data.save"
	var save_game = File.new()
	if not save_game.file_exists(filename):
		return
	save_game.open(filename, File.READ)
	game_data = parse_json(save_game.get_as_text())


func calc_name_from_res(level):
	return level.replace(".tscn", "").replace("_" ," ")


func start_level(mode, level):
	print("Start level: " + level)
	Global.level_res = level
	Global.level_name = calc_name_from_res(level)
	Global.mode = mode
	get_tree().change_scene("res://scenes/InGame.tscn")
	
func set_axis_scale(ax_sc):
	axis_scale = ax_sc
	COORDINATE_SYSTEM_SIZE = COORDINATE_SYSTEM_PIXEL_SIZE / axis_scale
