tool
extends CanvasItem

const COORDINATE_SYSTEM_SIZE = Global.COORDINATE_SYSTEM_SIZE

const axis_label_length = Global.axis_label_length

var axis_scale = 0

const stroke_width = Global.stroke_width

export(Font) var font


var x_axis_array = []
var y_axis_array = []


func _ready():
	if Engine.editor_hint:
		axis_scale = get_parent().axis_scale
		# y-axis numbers
		for i in range(-COORDINATE_SYSTEM_SIZE, COORDINATE_SYSTEM_SIZE):
			if i != 0:
				var label = Label.new()
				label.rect_min_size = Vector2(50,20)
				label.align = Label.ALIGN_RIGHT
				#label.anchor_left = 0.5
				#label.anchor_right = 0.5
				label.set_position(Vector2(-65, -axis_scale*i - 10))
				label.add_font_override("font", font)
				label.modulate = Color(1,1,1,0.7)
				label.text = str(i)
				add_child(label)
		# x-axis numbers
		for i in range(-COORDINATE_SYSTEM_SIZE, COORDINATE_SYSTEM_SIZE):
			if i != 0:
				var label = Label.new()
				label.rect_min_size = Vector2(50,20)
				label.align = Label.ALIGN_CENTER
				#label.anchor_left = 0.5
				#label.anchor_right = 0.5
				label.set_position(Vector2(-25 + axis_scale*i, +10))
				label.add_font_override("font", font)
				label.text = str(i)
				add_child(label)
		# x-axis
		for i in range(-COORDINATE_SYSTEM_SIZE, COORDINATE_SYSTEM_SIZE):
			x_axis_array.append(Vector2(axis_scale*i - axis_scale,0))
			x_axis_array.append(Vector2(axis_scale*i, 0))
			x_axis_array.append(Vector2(axis_scale*i, - axis_label_length))
			x_axis_array.append(Vector2(axis_scale*i, axis_label_length))
			
		# y-axis
		for i in range(-COORDINATE_SYSTEM_SIZE, COORDINATE_SYSTEM_SIZE):
			y_axis_array.append(Vector2(0, axis_scale*i - axis_scale))
			y_axis_array.append(Vector2(0, axis_scale*i))
			y_axis_array.append(Vector2(-axis_label_length, axis_scale*i))
			y_axis_array.append(Vector2(axis_label_length, axis_scale*i))

func _draw():
	if Engine.editor_hint:
		_draw_axis()


func _draw_axis():
	draw_multiline(x_axis_array, ColorN("slateblue"), stroke_width)
	draw_multiline(y_axis_array, ColorN("slateblue"), stroke_width)
	
