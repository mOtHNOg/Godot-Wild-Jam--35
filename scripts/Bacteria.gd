extends Area2D

# node references (just for fun)
onready var explode_timer_delay = $Timers/ExplodeStartDelay
onready var explode_timer = $Timers/ExplodeTimer
onready var explode_progress_bar = $ExplodeProgressBar

signal exploded

func _physics_process(delta):
	
	# update explode timer progress bar hud element
	if explode_timer.time_left > 0:
		var explode_time_left_percent = explode_timer.time_left / explode_timer.wait_time
		explode_progress_bar.value = 1 - explode_time_left_percent

func _on_ExplodeStartDelay_timeout():
	explode_timer.start()


func _on_ExplodeTimer_timeout():
	emit_signal("exploded")
