extends ColorRect

enum {FADING_IN, FADING_OUT}
var status = FADING_IN

onready var tween = $Tween

var transition_speed: float = 2
var transparent_color: Color = Color(0, 0, 0, 0)

# same as transparent color but fully opaque
var opaque_color: Color = Color(transparent_color.r, transparent_color.b, transparent_color.g, 1)

signal fully_opaque
var signal_recipient: Node = null
var signal_method: String

func _ready():
	connect("fully_opaque", signal_recipient, signal_method)
	
	color = transparent_color
	
	tween.interpolate_property(self, "color", transparent_color, opaque_color,
		transition_speed / 2, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	if status == FADING_IN:
		emit_signal("fully_opaque")
		
		# start fating out
		tween.interpolate_property(self, "color", opaque_color, transparent_color,
			transition_speed / 2, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		
		status = FADING_OUT
	
	else:
		queue_free()



