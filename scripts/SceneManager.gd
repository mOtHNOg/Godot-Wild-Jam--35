extends Node 

# NODESSSSSSSSSS
onready var transitions = $CanvasLayer/Transitions
onready var view_switch_button = $CanvasLayer/UI_HUD/ViewSwitchButton
onready var sfx_click = $SFX/Click
onready var sfx_toothbrush = $SFX/Toothbrush
onready var sfx_activity_warning = $SFX/ActivityWarning
onready var music = $Music/Music
onready var activity_warning_label = $CanvasLayer/UI_HUD/ActivityWarning
onready var activity_warning_timer = $CanvasLayer/UI_HUD/ActivityWarning/BlinkTimer

var switch_view_hotkey_pressed: bool = false

# music audio effect variables
onready var music_bus_index: int = AudioServer.get_bus_index("Music")
onready var music_lfo_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(music_bus_index, 0)
const max_music_lfo_cutoff_hz = 15000
const min_music_lfo_cutoff_hz = 1000
var music_lfo_speed: float = 8

# ui / hud stuff
var button_textures: Dictionary = {
	"to_wall_normal" : load("res://assets/art/ui/to wall button/normal.png"),
	"to_wall_hover" : load("res://assets/art/ui/to wall button/hover.png"),
	"to_wall_pressed" : load("res://assets/art/ui/to wall button/pressed.png"),
	"to_mouth_normal" : load("res://assets/art/ui/to mouth button/normal.png"),
	"to_mouth_hover" : load("res://assets/art/ui/to mouth button/hover.png"),
	"to_mouth_pressed" : load("res://assets/art/ui/to mouth button/pressed.png")
}

var activity_warning_shown: bool = false

var needs_disabling_group_name_template: String = "needs_disabling_{view}"
var needs_disabling_groups: Dictionary

func _ready():
	Global.views.active = Global.mouth
	Global.views.inactive = Global.wall
	
	if Global.did_tutorial == true:
		Global.screen_flash(Global.mouth, 0.5, Color(0.988, 0.961, 0.757, 0.9))

func _process(delta):
	
	needs_disabling_groups= {
		"active" : needs_disabling_group_name_template.format({"view" : Global.views.active.name}),
		"inactive" : needs_disabling_group_name_template.format({"view" : Global.views.inactive.name})
	}
	
	# update nodes that need disabling / enabling
	for active_nodes in get_tree().get_nodes_in_group(needs_disabling_groups.active):
		active_nodes.disabled = false
	for inactive_nodes in get_tree().get_nodes_in_group(needs_disabling_groups.inactive):
		inactive_nodes.disabled = true
	
	# switch view hotkey detection
	if Input.is_action_just_pressed("space") and switch_view_hotkey_pressed == false:
		switch_view_hotkey_pressed = true
		Global.view_transition(transitions, self, "_on_view_transition_covered", "_on_view_transition_over", 0.75)
	
	# apply music lfo effect
	if Global.views.active == Global.mouth:
		music_lfo_effect.cutoff_hz = lerp(music_lfo_effect.cutoff_hz, max_music_lfo_cutoff_hz, music_lfo_speed * delta)
		
		# handle activity warning stuff
		if Global.toothbrush_exists == true and Global.has_toothbrush == false:
			if activity_warning_shown == false:
				activity_warning_shown = true
				sfx_toothbrush.stop()
				activity_warning_label.show()
				sfx_activity_warning.play()
				activity_warning_timer.start()
		
		elif Global.has_toothbrush == true:
			activity_warning_shown = false
			activity_warning_timer.stop()
			activity_warning_label.hide()
			
			if sfx_toothbrush.playing == false:
				sfx_toothbrush.play()
	
	
	# still applying music lfo effect
	else:
		music_lfo_effect.cutoff_hz = lerp(music_lfo_effect.cutoff_hz, min_music_lfo_cutoff_hz, music_lfo_speed * delta)
		
		# still handling activity warning stuff
		activity_warning_shown = false
		activity_warning_label.hide()
		activity_warning_timer.stop()
		
		
		if Global.toothbrush_exists == true and Global.has_toothbrush == false:
			if sfx_toothbrush.playing == false:
				sfx_toothbrush.play()
		elif Global.toothbrush_exists == Global.has_toothbrush == true:
			sfx_toothbrush.stop()

func _on_view_transition_covered() -> void:
	Global.views = Global.swap_dict_values(Global.views)
	
	# update button textures
	if Global.views.active == Global.mouth:
		view_switch_button.texture_normal = button_textures.to_wall_normal
		view_switch_button.texture_hover = button_textures.to_wall_hover
		view_switch_button.texture_pressed = button_textures.to_wall_pressed
	else:
		view_switch_button.texture_normal = button_textures.to_mouth_normal
		view_switch_button.texture_hover = button_textures.to_mouth_hover
		view_switch_button.texture_pressed = button_textures.to_mouth_pressed
		
		# get rid of screen flashes when transitioning to mouth
		get_tree().call_group("screen_flash", "queue_free")

func _on_view_transition_over() -> void:
	# enable button / hotkey
	switch_view_hotkey_pressed = false
	view_switch_button.disabled = false

func _on_ViewSwitchButton_pressed():
	view_switch_button.disabled = true
	sfx_click.play()
	Global.view_transition(transitions, self, "_on_view_transition_covered", "_on_view_transition_over", 0.75)


func _on_BlinkTimer_timeout():
	activity_warning_label.visible = ! activity_warning_label.visible
	if activity_warning_label.visible == true:
		sfx_activity_warning.play()
