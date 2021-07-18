extends Node2D

# node references
onready var spawn_timer = $SpawnTimer
onready var phase_timer = $PhaseTimer
onready var bacteria_parent = get_parent().get_node("BacteriaParent")


const Bacteria = preload("res://scenes/Bacteria.tscn")

var spawn_data: Dictionary = {
	"phase_time" : 20,
	"min_spawn_time" : 3,
	"max_spawn_time" : 5,
	"max_cluster_size" : 3,
	"shielded_chance" : 0.0,
	"explosive_chance" : 0.0
}

var phase_data: Dictionary = {
	"2" : [15, 2, 4, 3, 0, 0.3],
	"3" : [15, 2, 4, 3, 0.66, 0.15],
	"4" : [20, 2, 3, 3, 0, 0.75],
	"5" : [32, 1, 3, 3, 0.87, 0.4]
}

var current_phase: int = 1

export var bacteria_move_area_boundaries = [Vector2(), Vector2()]

signal all_phases_complete
var signal_emitted: bool = false

func _ready():
	
	connect("all_phases_complete", Global.wall, "_spawn_toothbrush")
	
	spawn_bacteria()
	
	phase_timer.wait_time = spawn_data.phase_time
	phase_timer.start()
	


func spawn_bacteria() -> void:
	var spawn_amount = int(rand_range(1, spawn_data.max_cluster_size + 1))
	for i in range(spawn_amount):
		var bacteria_instance: Bacteria = Bacteria.instance()
		
		# set important properties before adding
		bacteria_instance.position = global_position
		bacteria_instance.move_area_boundaries = bacteria_move_area_boundaries
		
		# randomly set to explosive or shielded based on spawn data
		if randf() < spawn_data.shielded_chance:
			bacteria_instance.shielded = true
		if randf() < spawn_data.explosive_chance:
			bacteria_instance.shielded = false
			bacteria_instance.explosive = true
		
		bacteria_parent.call_deferred("add_child", bacteria_instance)
		if i == spawn_amount:
			break
		else:
			yield(get_tree().create_timer(0.5), "timeout")
	
	# bacteria only spawn precisely on a second
	spawn_timer.wait_time = int(rand_range(spawn_data.min_spawn_time, spawn_data.max_spawn_time + 1))
	spawn_timer.start()



func _on_SpawnTimer_timeout() -> void:
	spawn_bacteria()


func _on_PhaseTimer_timeout():
	current_phase += 1
	
	if current_phase <= phase_data.keys().size() + 1:
#		print(current_phase)
#		print("phase ", current_phase, " data: ", phase_data[str(current_phase)])
		
		spawn_data = Global.set_dict_to_array(spawn_data, phase_data[str(current_phase)])
		
		phase_timer.wait_time = spawn_data.phase_time
		phase_timer.start()
		print(current_phase)
	
	# once all phases finish
	elif signal_emitted == false:
		print("done!")
		emit_signal("all_phases_complete")
		signal_emitted = true
