extends Node2D

# node REFERENCES!!!!!!
onready var bacteria_parent = $BacteriaParent
onready var teeth_background = $TeethBackground
onready var teeth_foreground = $TeethForeground

var damaged_teeth_textures: Dictionary = {
	"slightly_damaged" : {
		"background" : load("res://assets/art/backgrounds/teeth/background/slightly damaged.png"), 
		"foreground" : load("res://assets/art/backgrounds/teeth/foreground/slightly damaged.png")
		},
	"greatly_damaged" : {
		"background" : load("res://assets/art/backgrounds/teeth/background/greatly damaged.png"), 
		"foreground" : load("res://assets/art/backgrounds/teeth/foreground/greatly damaged.png")
		}
}

var disabled: bool = false

func _ready() -> void:
	Global.mouth = self
	print(damaged_teeth_textures["slightly_damaged"]["background"])

func _physics_process(_delta):
	# when disabled is true, visible will be false and vice versa
	visible = ! disabled
	bacteria_parent.visible = ! disabled
	
	if teeth_background != null:
		if Global.teeth_health_percent <= 0:
			teeth_background.hide()
			teeth_foreground.hide()
		elif Global.teeth_health_percent < 0.335:
			teeth_background.texture = damaged_teeth_textures["greatly_damaged"]["background"]
			teeth_foreground.texture = damaged_teeth_textures["greatly_damaged"]["foreground"]
		elif Global.teeth_health_percent < 0.667:
			teeth_background.texture = damaged_teeth_textures["slightly_damaged"]["background"]
			teeth_foreground.texture = damaged_teeth_textures["slightly_damaged"]["foreground"]



func _on_bacteria_exploded() -> void:
	Global.teeth_health -= 1
