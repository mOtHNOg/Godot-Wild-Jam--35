extends Node

# NODES!
onready var animation_player = $AnimationPlayer
onready var labels = $Labels
onready var top_label = $Labels/TopText
onready var bottom_label = $Labels/BottomText
onready var sfx_explosion = $SFX/Explosion


var bottom_text: Dictionary = {
	"1" : "But brushing your teeth without it went so well you might just keep using your fingers.",
	"2" : "Unfortunately you still don't know where your dental floss is... Or your toothpicks..... Or your mouthwash......",
	"3" : "But it won’t be much use to you now that all your teeth are gone."
}

func _ready():
	
	print(Global.teeth_health_percent)
	
	var end_screen_animation: String = "EndScreen"
	
	if Global.teeth_health_percent >= 0.75:
		bottom_label.text = bottom_text["1"]
	
	elif Global.teeth_health_percent < 0.75 and Global.teeth_health_percent > 0:
		bottom_label.text = bottom_text["2"]
		end_screen_animation = "EndScreen2"
	
	elif Global.teeth_health_percent <= 0:
		bottom_label.text = bottom_text["3"]
	
	animation_player.play(end_screen_animation)
	
	sfx_explosion.play()
