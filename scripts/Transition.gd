extends ColorRect

enum {TRANSITIONING_IN, TRANSITIONING_OUT}
var status = TRANSITIONING_IN

onready var tween = $Tween
onready var transition_sound = $TransitionSound

var transition_speed: float = 2
var transition_color: Color = Color(0, 0, 0, 1)

var start_pos = Vector2(-370, 0)
var mid_pos = Vector2.ZERO
var end_pos = -start_pos
var reversed: bool = false

signal fully_covered
signal transition_over
var signal_recipient: Node = null
var signal_covered_method: String
var signal_over_method: String = ""

func _ready():
	
	if reversed == true:
		start_pos *= -1
		end_pos *= -1
	Global.last_transition_reversed = reversed
	
	
	connect("fully_covered", signal_recipient, signal_covered_method)
	if signal_over_method != "":
		connect("transition_over", signal_recipient, signal_over_method)
	
	color = transition_color
	
	transition_sound.play()
	tween.interpolate_property(self, "rect_position", start_pos, mid_pos,
		transition_speed / 2, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	if status == TRANSITIONING_IN:
		emit_signal("fully_covered")
		
		# start transitioning out
		tween.interpolate_property(self, "rect_position", mid_pos, end_pos,
			transition_speed / 2, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		status = TRANSITIONING_OUT
	
	else:
		if signal_over_method != "":
			emit_signal("transition_over")
		queue_free()



