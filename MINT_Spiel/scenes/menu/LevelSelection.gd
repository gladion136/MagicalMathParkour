extends Control

onready var main = get_parent()
export(Font) var font
export(Resource) var jump_stats_scene
export(Resource) var star_stats_scene


enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

var levels = []


func _ready():
	pass


func on_open():
	for child in $ScrollContainer/GridContainer.get_children():
		$ScrollContainer/GridContainer.remove_child(child)
	print(main.current_mode)
	levels = list_files_in_directory("res://level/")
	levels.sort()
	print(levels)
	for i in range(levels.size()):
		var level = levels[i]
		var create = false
		if main.current_mode == MODE.LINEAR and "Linear" in level:
			create = true
		elif main.current_mode == MODE.QUAD and "Quad" in level:
			create = true
		elif main.current_mode == MODE.SIN and "Sin" in level:
			create = true
		elif main.current_mode == MODE.MULTI:
			create = true
		
		if create:
			var vbox = VBoxContainer.new()
			# Label
			var label_name = Label.new()
			var level_name = level.replace(".tscn", "").replace("_" ," ")
			label_name.align = HALIGN_CENTER
			label_name.text = level_name
			label_name.add_font_override("font", font)
			label_name.size_flags_horizontal = SIZE_EXPAND_FILL
			
			# Viewport
			var viewport_c = ViewportContainer.new()
			var viewport = Viewport.new()
			viewport.set_size_override(true, Vector2(1024, 600))
			viewport.size_override_stretch = true
			
			viewport_c.stretch = true
			viewport_c.rect_min_size = Vector2(204, 120)
			viewport_c.rect_size = Vector2(1024, 600)
			viewport_c.rect_scale = Vector2(0.2,0.2)
			viewport_c.add_child(viewport)
			viewport_c.connect("gui_input", self, "gui_input_viewport",[level, level_name])
			var level_instance = load("res://level/"+level).instance()
			viewport.add_child(level_instance)
			
			# Stats
			level_instance.count_stars()
			var loaded_stats = Global.get_stats(level)
			var star_highscore = 0
			var jump_highscore = "-"
			if loaded_stats != null:
				star_highscore = loaded_stats["stars_collected"] 
				jump_highscore = loaded_stats["used_jumps"]
				
			var hbox_stats = HBoxContainer.new()
			var star_stats = star_stats_scene.instance()
			star_stats.get_node("StarsCollected").text = str(star_highscore) + " / " + str(level_instance.star_count)
			hbox_stats.add_child(star_stats)
			var jump_stats = jump_stats_scene.instance()
			jump_stats.get_node("JumpsRemainig").text = str(jump_highscore) + " / " + str(level_instance.amount_jumps)
			hbox_stats.add_child(jump_stats)
			
			
			vbox.rect_min_size = Vector2(204,120)
			vbox.add_child(label_name)
			vbox.add_child(hbox_stats)
			vbox.add_child(viewport_c)
			var margin_container = MarginContainer.new()
			margin_container.add_child(vbox)
			margin_container.add_constant_override("margin_bottom", 30)
			margin_container.add_constant_override("margin_left", 10)
			margin_container.add_constant_override("margin_right", 10)
			$ScrollContainer/GridContainer.add_child(margin_container)


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files


func _on_Button_pressed():
	main.select_menu(main.MENU.MAIN)


func start_level(level, name):
	print("Start level: " + level)
	Global.level_res = level
	Global.level_name = name
	Global.mode = main.current_mode
	get_tree().change_scene("res://scenes/InGame.tscn")


func gui_input_viewport(event, level, level_name):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		start_level(level, level_name)
