extends Node2D

# node references
onready var tween = $Tween
onready var finger = $Finger

const rotation_speed = 10
const poke_distance = 160
const arm_extend_time = 0.083
const arm_retract_speed = 7

var rest_pos = position
var extending: bool = false

var mouse_pos: Vector2
var angle_to_mouse_pos: float
var direction_to_mouse_pos: Vector2

func _physics_process(delta):
	
	mouse_pos = get_global_mouse_position()
	angle_to_mouse_pos = (mouse_pos - rest_pos).angle()
	direction_to_mouse_pos = rest_pos.direction_to(mouse_pos)
	
	# points towards mouse pos smoothly
	global_rotation = lerp_angle(global_rotation, angle_to_mouse_pos, rotation_speed * delta)
	
	# only lets you poke if your mouse is to the right of the finger (because it makes sense)
	if Input.is_action_just_pressed("finger_poke") and mouse_pos.x > finger.global_position.x:
		
		# only lets you poke if you are retracted (6 seemed like a nice number)
		if position.distance_to(rest_pos) < 6:
			extending = true
			
			var extended_position: Vector2 = rest_pos + direction_to_mouse_pos * finger.global_position.distance_to(mouse_pos)
			tween.interpolate_property(self, "position",
				position, extended_position, arm_extend_time,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
	
	if extending == false:
		position = lerp(position, rest_pos, arm_retract_speed * delta)

func _on_Tween_tween_all_completed():
	extending = false
