extends Node2D

var teeth_health: int = 5

func _ready() -> void:
	Global.mouth = self

func _physics_process(_delta):
	if teeth_health == 0:
		print("you lose")

func _on_bacteria_exploded() -> void:
	teeth_health -= 1
