extends Control

onready var main = get_parent()

enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

func _on_BtnLinear_pressed():
	main.current_mode = MODE.LINEAR
	main.select_menu(main.MENU.LEVELSELECTION)


func _on_BtnQuad_pressed():
	main.current_mode = MODE.QUAD
	main.select_menu(main.MENU.LEVELSELECTION)


func _on_BtnSin_pressed():
	main.current_mode = MODE.SIN
	main.select_menu(main.MENU.LEVELSELECTION)


func _on_BtnMulti_pressed():
	main.current_mode = MODE.MULTI
	main.select_menu(main.MENU.LEVELSELECTION)
