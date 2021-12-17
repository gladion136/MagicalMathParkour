extends VideoPlayer

var timer
func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "after_pause", [])
	timer.one_shot = true
	add_child(timer)
	
func _on_VideoPlayer_finished():
	timer.start(.5)

func after_pause():
	play()
