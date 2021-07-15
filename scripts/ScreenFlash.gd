extends CanvasLayer

# node references
onready var color_rect = $ColorRect
onready var tween = $Tween

var flash_color: Color = Color(1, 1, 1, 1)
var flash_time: float

func _ready():
	if Global.flash_effects == false:
		queue_free()
	
	# interpolates from opaque to transparent
	var tween_final_value: Color = Color(flash_color.r, flash_color.g, flash_color.b, 0)
	tween.interpolate_property(color_rect, "modulate", flash_color, tween_final_value, flash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	queue_free()
