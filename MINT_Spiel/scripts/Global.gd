extends Node

enum MODE {
	LINEAR,
	QUAD
	SIN,
	MULTI
}

var level_res = ""
var level_name = ""
var mode = MODE.LINEAR

const COORDINATE_SYSTEM_SIZE = 200
const axis_label_length = 10
const axis_scale = 150
const stroke_width = 20


var coordinate_system_center = Vector2.ZERO
