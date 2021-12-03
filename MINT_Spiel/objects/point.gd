extends Node2D

onready var old_pos = Vector2(0, 0)

func _ready():
	$DontDespawn.start()


func _process(delta):
	var l_pos_x = (self.position.x - Global.coordinate_system_center.x) / Global.axis_scale
	var l_pos_y = (self.position.y - Global.coordinate_system_center.y) / Global.axis_scale * -1
	var cur_pos = Vector2(l_pos_x, l_pos_y)
	if old_pos != cur_pos:
		old_pos = cur_pos
		$Label.text = "("+str(stepify(cur_pos.x, 0.01))+", "+str(stepify(cur_pos.y, 0.01))+")"


func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			print("OK1")
			
			if $DontDespawn.is_stopped():
				queue_free()
				print("OK2")
