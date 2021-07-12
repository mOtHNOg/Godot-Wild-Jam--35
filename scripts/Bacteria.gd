extends Area2D
class_name Bacteria

# node references (just for fun)
onready var explode_timer_delay = $Timers/ExplodeStartDelay
onready var explode_timer = $Timers/ExplodeTimer
onready var move_delay_timer = $Timers/MoveDelayTimer
onready var explode_progress_bar_parent = $ExplodeProgressBar
onready var explode_progress_bar = $ExplodeProgressBar/ProgressBar
onready var progress_bar_background = $ExplodeProgressBar/Background
onready var sprite = $BacteriaSprite
onready var collision = $CollisionShape2D
onready var shield = $Shield
onready var shield_sprite = $Shield/ShieldSprite
onready var sfx_die = $SFX/Die
onready var sfx_shield_destroy = $SFX/ShieldDestroy

# bacteria will move to random positions within these vectors
var move_area_boundaries = [Vector2(), Vector2()]

# combat stuff???
var shielded: bool = false
var explosive: bool = false

const shielded_progress_bar_offset = Vector2(0, -5)

# movement variables
const min_speed = 90
const max_speed = 180
onready var random_speed = rand_range(min_speed, max_speed)

var move_pos: Vector2
var movement_direction: Vector2
signal finished_moving
var emitted_finished_moving_signal: bool = false

# timersssss
const min_explode_time = 7
const max_explode_time = 12

# visual stuff
onready var unique_sprite_material = sprite.material.duplicate()
onready var sprite_rotation_speed = random_speed * 2
var possible_rotation_directions = [-1, 1]
onready var random_rotation_direction = possible_rotation_directions[int(rand_range(0, possible_rotation_directions.size()))]

signal exploded

func _ready() -> void:
	connect("finished_moving", self, "set_movement_delay")
	connect("exploded", Global.mouth, "_on_bacteria_exploded")
	
	explode_timer.wait_time = int(rand_range(min_explode_time, max_explode_time))
	
	# set random sprite startign rotation (so there's more variety)
	sprite.rotation_degrees = rand_range(0, 360)
	
	if shielded == true:
		shield_sprite.show()
		
		# disable collision for bacteria so it will only hit shield collision
		collision.set_deferred("disabled", true)
		explode_progress_bar_parent.position += shielded_progress_bar_offset
	
	else:
		shield.queue_free()
	
	# if explosive it is all black
	if explosive == true:
		sprite.modulate = Color(0, 0, 0, 1)
	
	# if not explosive gives sprite a random hue
	else:
		var random_hue = randf()
		sprite.material = unique_sprite_material
		sprite.material.set_shader_param("Shift_Hue", random_hue)
	
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
	queue_free()

func die() -> void:
	
	# hide hud
	progress_bar_background.hide()
	explode_progress_bar.hide()
	
	# stop stuff that will get in the way
	explode_timer.stop()
	collision.set_deferred("disabled", true)
	
	# play sound at random pitch
	sfx_die.pitch_scale = rand_range(0.833, 1.167)
	sfx_die.stop()
	sfx_die.play()
	
	# set animation and stop it from moving and spinning
	sprite.animation = "death"
	random_speed = 0
	sprite_rotation_speed = 0
	sprite.rotation_degrees = 0
	
	yield(sprite, "animation_finished")
	queue_free()

func _on_ExplodeStartDelay_timeout() -> void:
	explode_timer.start()

func _on_ExplodeTimer_timeout() -> void:
	explode()

func _on_MoveDelayTimer_timeout() -> void:
	set_movement_to_random_pos()

func _on_finger_collision(poked_with_toothbrush: bool) -> void:
	if poked_with_toothbrush == true:
		pass
	else:
		if explosive == true:
			explode()
		else:
			die()

func _on_Shield_area_entered(area):
	var arm: Node2D = area.get_parent()
	if arm.extending == true:
		# re enable bacteria collision
		collision.set_deferred("disabled", false)

		#	sfx_shield_destroy.pitch_scale = rand_range(0.833, 1.167)
		sfx_shield_destroy.play()

		shield_sprite.animation = "die"
		yield(shield_sprite, "animation_finished")
		shield.queue_free()

		explode_progress_bar_parent.position -= shielded_progress_bar_offset
