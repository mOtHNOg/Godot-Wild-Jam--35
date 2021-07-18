tool
extends Label
class_name LabelWithSound

onready var sfx_text = $Text

var previous_percent_visible: float = percent_visible

const text_sound_time = 10
var text_sound_time_left: int = 0

func _physics_process(delta):
	if previous_percent_visible != percent_visible:
		
		if text_sound_time_left == 0:
			
			sfx_text.pitch_scale = rand_range(0.667, 1.333)
			sfx_text.play()
			
			text_sound_time_left = text_sound_time
		else:
			text_sound_time_left -= 1
	
	previous_percent_visible = percent_visible
