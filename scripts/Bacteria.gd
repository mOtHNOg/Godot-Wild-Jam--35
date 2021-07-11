extends Area2D
class_name Bacteria

# node references (just for fun)
onready var explode_timer_delay = $Timers/ExplodeStartDelay
onready var explode_timer = $Timers/ExplodeTimer
onready var move_delay_timer = $Timers/MoveDelayTimer
onready var explode_progress_bar = $ExplodeProgressBar
onready var sprite = $AnimatedSprite

# bacteria will move to random positions within these vectors
var move_area_boundaries = [Vector2(), Vector2()]

# combat stuff???
var shielded: bool = false
var explosive: bool = false

# movement variables
const min_speed = 90
const max_speed = 180
var random_speed = rand_range(min_speed, max_speed)

var move_pos: Vector2
var movement_direction: Vector2
signal finished_moving
var emitted_finished_moving_signal: bool = false

# timersssss
const min_explode_time = 7
const max_explode_time = 12

# visual stuff
onready var unique_sprite_material = sprite.material.duplicate()
var sprite_rotation_speed = random_speed * 2
var possible_rotation_directions = [-1, 1]
var random_rotation_direction = possible_rotation_directions[int(rand_range(0, possible_rotation_directions.size()))]

signal exploded

func _ready() -> void:
	connect("finished_moving", self, "set_movement_delay")
	connect("exploded", Global.mouth, "_on_bacteria_exploded")
	
	explode_timer.wait_time = int(rand_range(min_explode_time, max_explode_time))
	
	sprite.rotation_degrees = rand_range(0, 360)
	sprite.material = unique_sprite_material
	sprite.material.set_shader_param("Shift_Hue", rand_range(0, 255))
	
	set_movement_to_random_pos()

func _physics_process(delta) -> void:
	# movement
	movement_direction = position.direction_to(move_pos)
	if position.distance_to(move_pos) < 1:
		move_pos = position
		
		if emitted_finished_moving_signal == false:
			emitted_finished_moving_signal = true
			emit_signal("finished_moving", 0.5, 1.5)
	else:
		position += random_speed * movement_direction * delta
	
	# update explode timer progress bar hud element
	if explode_timer.time_left > 0:
		var explode_time_left_percent = explode_timer.time_left / explode_timer.wait_time
		explode_progress_bar.value = 1 - explode_time_left_percent
	
	# spinnn!!!!
	sprite.rotation_degrees += sprite_rotation_speed * random_rotation_direction * delta

func set_movement_to_random_pos() -> void:
	emitted_finished_moving_signal = false
	
	var random_move_pos = Vector2(
		rand_range(move_area_boundaries[0].x, move_area_boundaries[1].x),
		rand_range(move_area_boundaries[0].y, move_area_boundaries[1].y)
	)
	move_pos = random_move_pos

func set_movement_delay(min_delay_time: float, max_delay_time: float) -> void:
	var delay_time = rand_range(min_delay_time, max_delay_time)
	move_delay_timer.wait_time = delay_time
	move_delay_timer.start()

func explode() -> void:
	Global.screen_flash(Global.mouth, 0.167, Color(1, 1, 1, 0.75))
	emit_signal("exploded")

func die() -> void:
	queue_free()

func _on_ExplodeStartDelay_timeout() -> void:
	explode_timer.start()

func _on_ExplodeTimer_timeout() -> void:
	explode()
	queue_free()

func _on_MoveDelayTimer_timeout() -> void:
	set_movement_to_random_pos()

func _on_finger_collision() -> void:
	if explosive == true:
		explode()
		die()
	elif shielded == false:
		die()
	else:
		shielded = false
