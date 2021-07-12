extends Node2D

# node references
onready var spawn_timer = $SpawnTimer
onready var bacteria_parent = get_parent().get_node("BacteriaParent")

const Bacteria = preload("res://scenes/Bacteria.tscn")

var spawn_data: Dictionary = {
	"min_spawn_time" : 2,
	"max_spawn_time" : 4,
	"shielded_chance" : 0.25,
	"explosive_chance" : 0.25
}

var phase_2_data: Dictionary

export var min_spawn_time: int
export var max_spawn_time: int

export var auto_start: bool = false
export var bacteria_move_area_boundaries = [Vector2(), Vector2()]

func _ready():
	if auto_start == true:
		start()

func start() -> void:
	spawn_bacteria()
	
	# bacteria only spawn precisely on a second
	spawn_timer.wait_time = int(rand_range(spawn_data.min_spawn_time, spawn_data.max_spawn_time))
	spawn_timer.start()

func stop() -> void:
	spawn_timer.stop()

func spawn_bacteria() -> void:
	var spawn_amount = int(rand_range(0, 4))
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

func _on_SpawnTimer_timeout() -> void:
	spawn_bacteria()
