extends Area2D
class_name Bacteria

# node references (just for fun)
onready var explode_timer_delay = $Timers/ExplodeStartDelay
onready var explode_timer = $Timers/ExplodeTimer
onready var move_delay_timer = $Timers/MoveDelayTimer
onready var explode_progress_bar = $ExplodeProgressBar

# bacteria will move to random positions within these vectors
var move_area_boundaries = [Vector2(), Vector2()]

# movement variables
const min_speed = 60
const max_speed = 200
var random_speed = rand_range(min_speed, max_speed)

var move_pos: Vector2
var movement_direction: Vector2
signal finished_moving
var emitted_finished_moving_signal: bool = false

# timersssss
const min_explode_time = 7
const max_explode_time = 12

signal exploded

func _ready() -> void:
	connect("finished_moving", self, "set_movement_delay")
	
	explode_timer.wait_time = int(rand_range(min_explode_time, max_explode_time))
	
	set_movement_to_random_pos()
	$Label.text = str(int(random_speed))

func _physics_process(delta) -> void:
	# movement
	movement_direction = position.direction_to(move_pos)
	if position.distance_to(move_pos) < 1:
		move_pos = position
		
		if emitted_finished_moving_signal == false:
			emitted_finished_moving_signal = true
			emit_signal("finished_moving", 2, 4)
	else:
		position += random_speed * movement_direction * delta
	
	# update explode timer progress bar hud element
	if explode_timer.time_left > 0:
		var explode_time_left_percent = explode_timer.time_left / explode_timer.wait_time
		explode_progress_bar.value = 1 - explode_time_left_percent

func set_movement_to_random_pos() -> void:
	emitted_finished_moving_signal = false
	
	var random_move_pos = Vector2(
		rand_range(move_area_boundaries[0].x, move_area_boundaries[1].x),
		rand_range(move_area_boundaries[0].y, move_area_boundaries[1].y)
	)
	move_pos = random_move_pos

func set_movement_delay(min_delay_time: int, max_delay_time: int) -> void:
	var delay_time = int(rand_range(min_delay_time, max_delay_time))
	move_delay_timer.wait_time = delay_time
	move_delay_timer.start()

func _on_ExplodeStartDelay_timeout() -> void:
	explode_timer.start()

func _on_ExplodeTimer_timeout() -> void:
	emit_signal("exploded")
	queue_free()

func _on_MoveDelayTimer_timeout() -> void:
	set_movement_to_random_pos()

func _on_finger_collision() -> void:
	queue_free()
