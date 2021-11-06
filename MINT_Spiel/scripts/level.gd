extends Node2D
class_name Level

enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

export(int) var amount_jumps = 3
export(MODE) var current_mode = MODE.LINEAR


func _ready():
	pass

func _process(delta):
	pass
