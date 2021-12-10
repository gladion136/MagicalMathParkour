extends Node2D
class_name Level

enum MODE {
	LINEAR,
	QUAD,
	SIN,
	MULTI
}

export(int) var amount_jumps = 3
var star_count = 0

func _ready():
	count_stars()


func count_stars():
	for node in get_children():
		if node.get_class() == "Star":
			star_count += 1


func _process(delta):
	pass
