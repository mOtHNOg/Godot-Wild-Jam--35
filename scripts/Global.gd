extends Node

var picked_up_wall_object: WallObject = null

func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = ! OS.window_fullscreen
