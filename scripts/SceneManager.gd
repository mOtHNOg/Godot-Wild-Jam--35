extends Node 

# NODESSSSSSSSSS
onready var transitions = $CanvasLayer/Transitions

var needs_disabling_group_name_template: String = "needs_disabling_{view}"


#func _ready():
#	print(Global.views)
#	Global.views = Global.swap_dict_values(Global.views)
#	print(Global.views)

func _process(_delta):
	var needs_disabling_groups: Dictionary = {
		"active" : needs_disabling_group_name_template.format({"view" : Global.views.active.name}),
		"inactive" : needs_disabling_group_name_template.format({"view" : Global.views.inactive.name})
	}
#	print(needs_disabling_groups)
	
	for active_nodes in get_tree().get_nodes_in_group(needs_disabling_groups.active):
		active_nodes.disabled = false
	for inactive_nodes in get_tree().get_nodes_in_group(needs_disabling_groups.inactive):
		inactive_nodes.disabled = true
	
	if Input.is_action_just_pressed("down"):
		Global.view_transition(transitions, self, "_on_view_transition_covered", "_on_view_transition_over", 0.75)

func _on_view_transition_covered() -> void:
	Global.views = Global.swap_dict_values(Global.views)

func _on_view_transition_over() -> void:
	pass
