extends Node

# NO
onready var background = $Background
onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var monologue: Dictionary = {
	"dinner" : $MonologueLabels/DinnerLastNight, 
	"toothbrush" : $MonologueLabels/WhereToothbrush,
	"brushteeth" : $MonologueLabels/BrushTeeth}
onready var tutorials: Dictionary = {
	"open_droor" : $TutorialLabels/OpenDroor, 
	"continue" : $TutorialLabels/Continue,
	"start" : $TutorialLabels/Start
	}
onready var sfx: Dictionary = {"droor_open" : $SFX/DroorOpen}

# first value is whether the animation is completeed
# second value is whether the player has clicked after that animation
# second value is used so the player can only click once
var animation_completion: Dictionary = {
	"1" : [false, false],
	"2" : [false, false],
	"3" : [false, false],
	"4" : [false, false]
}

var current_tutorial_label: Label

func _ready():
	
	# was having some problems with labels starting visible
	# i don't think this actually does anything
	for label in monologue.values():
		if label is Label:
			label.percent_visible = 0
	
	animation_player.play("1")

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		
		if animation_completion["4"][0] == true and animation_completion["4"][1] == false:
			
			animation_completion["4"][1] = true
			get_tree().change_scene("res://scenes/TutorialPage.tscn")
			
		elif animation_completion["3"][0] == true and animation_completion["3"][1] == false:
			
			animation_completion["3"][1] = true
			
			monologue.brushteeth.queue_free()
			tutorials.continue.queue_free()
			animation_player.play("4")
			
		elif animation_completion["2"][0] == true and animation_completion["2"][1] == false:
			
			animation_completion["2"][1] = true
			
			monologue.toothbrush.queue_free()
			tween.stop_all()
			current_tutorial_label.modulate = Color(1, 1, 1, 0)
			animation_player.play("3")
			monologue.toothbrush.percent_visible = 0
			
		elif animation_completion["1"][0] == true and animation_completion["1"][1] == false:
			
			animation_completion["1"][1] = true
			background.frame += 1
			sfx.droor_open.play()
			
			monologue.dinner.queue_free()
			tutorials.open_droor.queue_free()
			animation_player.play("2")

func _on_AnimationPlayer_animation_finished(anim_name):
	animation_completion[anim_name][0] = true
	
	if anim_name == "1":
		current_tutorial_label = tutorials.open_droor
	elif anim_name == "2" or anim_name == "3":
		current_tutorial_label = tutorials.continue
	else:
		current_tutorial_label = tutorials.start
	
	tween.remove_all()
	tween.interpolate_property(current_tutorial_label, "modulate", Color(1, 1, 1, 0), Color.white,
		2, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
