extends Node

# preload
const screen_flash = preload("res://scenes/ScreenFlash.tscn")

# nodes
var mouth: Node2D
var wall: Node2D

# control
onready var current_view: Node = get_node("/root/SceneManager/Mouth")
var picked_up_wall_object: WallObject = null

# options
var flash_effects: bool = true


# built in functions
func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = ! OS.window_fullscreen

# my global functions
func screen_flash(where: Node, time: float = 0.2, color: Color = Color(1, 1, 1, 1)) -> void:
	var screen_flash_instance = screen_flash.instance()
	screen_flash_instance.flash_color = color
	screen_flash_instance.flash_time = time
	where.add_child(screen_flash_instance)
