extends Node2D

# node references
onready var tween = $Tween
onready var finger = $Finger
onready var sfx_poke = $SFX/Poke

var disabled: bool = false
var has_toothbrush: bool = false

const rotation_speed = 10 
const arm_extend_time = 0.2
const arm_retract_speed = 7
const additional_extend_distance = 10
const retracted_distance_to_rest_pos = 7

var rest_pos = position
var extending: bool = false
const poke_buffer_time = 20
var poke_buffer_time_left = 0

var mouse_pos: Vector2
var angle_to_mouse_pos: float
var direction_to_mouse_pos: Vector2


signal collided_with_bacteria

func _physics_process(delta):
	if disabled == false:
		mouse_pos = get_global_mouse_position()
		angle_to_mouse_pos = (mouse_pos - rest_pos).angle()
		direction_to_mouse_pos = rest_pos.direction_to(mouse_pos)
		
		# points towards mouse pos smoothly
		global_rotation = lerp_angle(global_rotation, angle_to_mouse_pos, rotation_speed * delta)
		
		# clamp rotation because it can look pretty funky sometimes
		global_rotation = clamp(global_rotation, -0.2, 0.2)
		
		# only lets you poke if your mouse is to the right of the finger (because it makes sense)
		if Input.is_action_just_pressed("left_click") and mouse_pos.x > finger.global_position.x:
			
			# only lets you poke if you are retracted enough
			if position.distance_to(rest_pos) < retracted_distance_to_rest_pos:
				poke()
			
			# if you click while not retracted you will buffer a poke for once you are retracted
			else:
				poke_buffer_time_left = poke_buffer_time
		
		if poke_buffer_time_left > 0:
			poke_buffer_time_left -= 1

			if position.distance_to(rest_pos) < retracted_distance_to_rest_pos:
				poke_buffer_time_left = 0
				poke()
		
		if extending == false:
			position = lerp(position, rest_pos, arm_retract_speed * delta)
	print(global_rotation)

func poke() -> void:
	extending = true
	
	sfx_poke.pitch_scale = rand_range(0.833, 1.167)
	sfx_poke.play()
	
	var extended_position: Vector2 = rest_pos + direction_to_mouse_pos * ( finger.global_position.distance_to(mouse_pos) + additional_extend_distance )
	tween.remove_all()
	tween.interpolate_property(self, "position",
		position, extended_position, arm_extend_time,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func stop_poke() -> void:
	tween.stop_all()
	extending = false

func _on_Tween_tween_completed(_object, _key):
	extending = false

func _on_Finger_area_entered(area):
	if extending == true:
		stop_poke()
		
		if area is Bacteria:
			connect("collided_with_bacteria", area, "_on_finger_collision")
			emit_signal("collided_with_bacteria", has_toothbrush)
