extends Node

# NODES!
onready var animation_player = $AnimationPlayer
onready var labels = $Labels
onready var top_label = $Labels/TopText
onready var bottom_label = $Labels/BottomText
onready var sfx_explosion = $SFX/Explosion
onready var sfx_text = $SFX/Text

var bottom_text: Dictionary = {
	"1" : "But brushing your teeth without it went so well you might just keep using your fingers.",
	"2" : "Unfortunately you still don't know where your dental floss is... Or your toothpicks..... Or your mouthwash......",
	"3" : "But it won’t be much use to you now that all your teeth are gone."
}

const text_sound_time = 10
var text_sound_time_left: int = 0

onready var current_revealing_label: Label = top_label
onready var previous_percent_visible: float = current_revealing_label.percent_visible

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

func _physics_process(delta):
	if current_revealing_label.percent_visible != previous_percent_visible:
		if text_sound_time_left == 0:
			
			sfx_text.pitch_scale = rand_range(0.667, 1.333)
			sfx_text.play()
			
			text_sound_time_left = text_sound_time
		else:
			text_sound_time_left -= 1
	
	if current_revealing_label == top_label and current_revealing_label.percent_visible == 1:
		current_revealing_label = bottom_label
	
	previous_percent_visible = current_revealing_label.percent_visible
