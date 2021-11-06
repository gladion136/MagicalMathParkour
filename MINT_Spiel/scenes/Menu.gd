extends Control

enum MENU {
	MAIN,
	SETTINGS,
	LEVELSELECTION
}

var current_menu = MENU.MAIN
var current_mode = null

func select_menu(new_menu):
	match current_menu:
		MENU.MAIN:
			$MainMenu.visible = false
		MENU.SETTINGS:
			$Settings.visible = false
		MENU.LEVELSELECTION:
			$LevelSelection.visible = false
	current_menu = new_menu
	match current_menu:
		MENU.MAIN:
			$MainMenu.visible = true
		MENU.SETTINGS:
			$Settings.visible = true
		MENU.LEVELSELECTION:
			$LevelSelection.visible = true
			$LevelSelection.on_open()
