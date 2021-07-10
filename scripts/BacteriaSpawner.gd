extends Node2D

# node references
onready var spawn_timer = $SpawnTimer
onready var parent = get_parent()

const Bacteria = preload("res://scenes/Bacteria.tscn")

export var min_spawn_time: int
export var max_spawn_time: int

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
	var bacteria_instance = Bacteria.instance()
	parent.call_deferred("add_child", bacteria_instance)
	bacteria_instance.position = global_position

func _on_SpawnTimer_timeout() -> void:
	spawn_bacteria()
