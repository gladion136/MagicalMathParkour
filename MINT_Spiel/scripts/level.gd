extends Node2D
class_name Level

enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

export(int) var amount_jumps = 3
export(int) var axis_scale = 150
export(bool) var pi_labeled_coordinate_system = false
var star_count = 0

func _ready():
	Global.set_axis_scale(axis_scale)
	Global.set_pi_labeled_coordinate_system(pi_labeled_coordinate_system)
	count_stars()


func count_stars():
	for node in get_children():
		if node.get_class() == "Star":
			star_count += 1


func _process(delta):
	pass
