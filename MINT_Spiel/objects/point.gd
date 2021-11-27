extends Node2D

onready var old_pos = position

func _ready():
	$DontDespawn.start()


func _process(delta):
	if position != old_pos:
		old_pos = position
		var l_pos_x = (self.position.x - Global.coordinate_system_center.x) / Global.axis_scale
		var l_pos_y = (self.position.y - Global.coordinate_system_center.y) / Global.axis_scale * -1
		$Label.text = "("+str(stepify(l_pos_x, 0.01))+", "+str(stepify(l_pos_y, 0.01))+")"


func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			print("OK1")
			
			if $DontDespawn.is_stopped():
				queue_free()
				print("OK2")
