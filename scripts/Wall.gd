extends Node2D

var disabled: bool = false

func _ready():
	Global.wall = self

func _process(_delta):
	visible = ! disabled
