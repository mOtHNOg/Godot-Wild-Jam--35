extends Node 

# NODESSSSSSSSSS
onready var transitions = $CanvasLayer/Transitions
onready var view_switch_button = $CanvasLayer/UI/ViewSwitchButton

var switch_view_hotkey_pressed: bool = false

var button_textures: Dictionary = {
	"to_wall_normal" : load("res://assets/art/ui/to wall button/normal.png"),
	"to_wall_hover" : load("res://assets/art/ui/to wall button/hover.png"),
	"to_wall_pressed" : load("res://assets/art/ui/to wall button/pressed.png"),
	"to_mouth_normal" : load("res://assets/art/ui/to mouth button/normal.png"),
	"to_mouth_hover" : load("res://assets/art/ui/to mouth button/hover.png"),
	"to_mouth_pressed" : load("res://assets/art/ui/to mouth button/pressed.png")
}

var needs_disabling_group_name_template: String = "needs_disabling_{view}"
var needs_disabling_groups: Dictionary

#func _ready():
#	print(Global.views)
#	Global.views = Global.swap_dict_values(Global.views)
#	print(Global.views)
#	print(button_textures)

func _process(_delta):
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

func _on_view_transition_over() -> void:
	# enable button / hotkey
	switch_view_hotkey_pressed = false
	view_switch_button.disabled = false

func _on_ViewSwitchButton_pressed():
	view_switch_button.disabled = true
	Global.view_transition(transitions, self, "_on_view_transition_covered", "_on_view_transition_over", 0.75)
