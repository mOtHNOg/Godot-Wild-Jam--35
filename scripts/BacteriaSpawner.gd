extends Node2D

# node references
onready var spawn_timer = $SpawnTimer
onready var bacteria_parent = get_parent().get_node("BacteriaParent")

const Bacteria = preload("res://scenes/Bacteria.tscn")

export var min_spawn_time: int
export var max_spawn_time: int
export var bacteria_move_area_boundaries = [Vector2(), Vector2()]
export var auto_start: bool = false

func _ready():
	if auto_start == true:
		start()

func start() -> void:
	spawn_bacteria()
	
	# int() makes it so bacteria only spawn precisely on a second
	spawn_timer.wait_time = int(rand_range(min_spawn_time, max_spawn_time))
	spawn_timer.start()

func stop() -> void:
	spawn_timer.stop()

func spawn_bacteria() -> void:
	var spawn_amount = int(rand_range(0, 4))
	for i in spawn_amount:
		print(i)
		var bacteria_instance: Bacteria = Bacteria.instance()
		bacteria_parent.call_deferred("add_child", bacteria_instance)
		bacteria_instance.position = global_position
		bacteria_instance.move_area_boundaries = bacteria_move_area_boundaries
		if i == spawn_amount:
			break
		else:
			yield(get_tree().create_timer(0.5), "timeout")

func _on_SpawnTimer_timeout() -> void:
	spawn_bacteria()
