extends Node2D

# node references
onready var spawn_timer = $SpawnTimer
onready var phase_timer = $PhaseTimer
onready var bacteria_parent = get_parent().get_node("BacteriaParent")


const Bacteria = preload("res://scenes/Bacteria.tscn")

var spawn_data: Dictionary = {
	"phase_time" : 5,
	"min_spawn_time" : 3,
	"max_spawn_time" : 6,
	"max_cluster_size" : 2,
	"shielded_chance" : 0.0,
	"explosive_chance" : 0.0
}

var phase_data: Dictionary = {
	"2" : [5, 3, 5, 2, 0.2, 0.2],
	"3" : [5, 3, 4, 3, 0.33, 0.33],
	"4" : [10, 2, 4, 3, 0, 0.75],
	"5" : [20, 2, 3, 3, 0.5, 0.33]
}

var current_phase: int = 1

export var min_spawn_time: int
export var max_spawn_time: int

export var auto_start: bool = false
export var bacteria_move_area_boundaries = [Vector2(), Vector2()]

func _ready():
	
	spawn_bacteria()
	
	spawn_timer.start()
	
	phase_timer.wait_time = spawn_data.phase_time
	phase_timer.start()
	
	print(spawn_data)
	spawn_data = Global.set_dict_to_array(spawn_data, phase_data["2"])
	print(spawn_data)


func spawn_bacteria() -> void:
	var spawn_amount = int(rand_range(0, spawn_data.max_cluster_size + 1))
	for i in spawn_amount:
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

func _on_SpawnTimer_timeout() -> void:
	spawn_bacteria()


func _on_PhaseTimer_timeout():
	current_phase += 1
	
#	print(current_phase)
#	print("phase ", current_phase, " data: ", phase_data[str(current_phase)])
	
	spawn_data = Global.set_dict_to_array(spawn_data, phase_data[str(current_phase)])
	
	phase_timer.wait_time = spawn_data.phase_time
	phase_timer.start()
