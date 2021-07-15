extends Node2D

# node REFERENCES!!!!!!
onready var bacteria_parent = $BacteriaParent

var disabled: bool = false

const max_teeth_health = 8
var teeth_health: int = max_teeth_health

func _ready() -> void:
	Global.mouth = self

func _physics_process(_delta):
	# when disabled is true, visible will be false and vice versa
	visible = ! disabled
	bacteria_parent.visible = ! disabled

func _on_bacteria_exploded() -> void:
	teeth_health -= 1
