extends Control

onready var main = get_parent()
export(Font) var font

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
	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
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
			var new_button = Button.new()
			var btn_text = level.replace(".tscn", "")
			btn_text = btn_text.replace("_" ," ")
			new_button.text = btn_text
			new_button.add_font_override("font", font)
			new_button.connect("pressed", self, "start_level", [level, btn_text])
			$VBoxContainer.add_child(new_button)


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
