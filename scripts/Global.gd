extends Node

# preload
const screen_flash_object = preload("res://scenes/ScreenFlash.tscn")
const transition_object = preload("res://scenes/Transition.tscn")

# nodes
var mouth: Node2D
var wall: Node2D

# control
var did_tutorial: bool = false

onready var views: Dictionary = {
	"active" : null,
	"inactive" : null
}

var picked_up_wall_object: WallObject = null

var toothbrush_exists: bool = false
var has_toothbrush: bool = false

# keeps track of health globally
const max_teeth_health = 6
var teeth_health: int = max_teeth_health
var teeth_health_percent: float = 1


# starts as true so the first transition will be not reversed
var last_transition_reversed: bool = true

# options
var flash_effects: bool = true


# built in functions
func _ready():
	randomize()
	

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = ! OS.window_fullscreen

func _process(delta):
	teeth_health_percent = teeth_health as float / max_teeth_health

# my global functions
func play_sound(where: Node, sound_path: String, volume: float = 0, pitch: float = 1):
	var audio_stream_player := AudioStreamPlayer.new()
	
	# set properties
	audio_stream_player.stream = load(sound_path)
	audio_stream_player.volume_db = volume
	audio_stream_player.pitch_scale = pitch
	
	# add and play
	where.add_child(audio_stream_player)
	audio_stream_player.play()
	
	# queue_free after it finishes playing
	yield(audio_stream_player, "finished")
	audio_stream_player.queue_free()

func screen_flash(where: Node, time: float = 0.2, color: Color = Color(1, 1, 1, 1)) -> void:
	var screen_flash_instance = screen_flash_object.instance()
	screen_flash_instance.flash_color = color
	screen_flash_instance.flash_time = time
	where.add_child(screen_flash_instance)

func swap_dict_values(dict: Dictionary) -> Dictionary:
	var dict_keys: Array = dict.keys()
	
	var value_1 = dict[dict_keys[0]]
	var value_2 = dict[dict_keys[1]]
	
	var new_dict = {
		dict_keys[0] : value_2,
		dict_keys[1] : value_1
	}
	return new_dict

func view_transition(where: Node, SceneManager: Node, transition_covered_method: String, transition_over_method: String = "", speed: float = 0.5, color: Color = Color(0, 0, 0, 1)) -> void:
	var transition_instance = transition_object.instance()
	
	transition_instance.transition_speed = speed
	transition_instance.transition_color = color
	transition_instance.signal_recipient = SceneManager
	transition_instance.signal_covered_method = transition_covered_method
	transition_instance.signal_over_method = transition_over_method
	
	where.add_child(transition_instance)

func set_dict_to_array(dict: Dictionary, array: Array) -> Dictionary:
	var dict_keys: Array = dict.keys()
	
	# doesn't work if dictionary and array aren't same length
	if dict_keys.size() != array.size():
		print("Error! dict and array's sizes don't match.")
		return dict
	
	var new_dict: Dictionary = dict.duplicate()
	
	for i in array.size():
		new_dict[dict_keys[i]] = array[i]
	
	return new_dict
