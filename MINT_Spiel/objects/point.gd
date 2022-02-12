extends Node2D

onready var old_pos = Vector2(0, 0)
var pi_labeled_coordinate_system

func _ready():
	$DontDespawn.start()
	pi_labeled_coordinate_system = Global.pi_labeled_coordinate_system


func _process(delta):
	var l_pos_x = (self.position.x - Global.coordinate_system_center.x) / Global.axis_scale
	var l_pos_y = (self.position.y - Global.coordinate_system_center.y) / Global.axis_scale * -1
	var cur_pos = Vector2(l_pos_x, l_pos_y)
	if old_pos != cur_pos:
		old_pos = cur_pos
		if pi_labeled_coordinate_system:
			$Label.text = "("+str(stepify(cur_pos.x/2, 0.01))+"π"+", "+str(stepify(cur_pos.y, 0.01))+")"
		else:
			$Label.text = "("+str(stepify(cur_pos.x, 0.01))+", "+str(stepify(cur_pos.y, 0.01))+")"


func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if $DontDespawn.is_stopped():
				queue_free()
