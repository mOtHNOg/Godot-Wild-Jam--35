extends Control

# NOSE
onready var labels = $Labels
onready var continue_button_text = $ContinueButton/Text
onready var sfx_click = $SFX/Click
onready var sfx_slide = $SFX/Slide

onready var labels_pos: Vector2 = labels.rect_position
var labels_speed: float = 6
var current_labels: int = 1



func _physics_process(delta):
	labels.rect_position = lerp(labels.rect_position, labels_pos, labels_speed * delta)

func _on_ContinueButton_area_entered(_area):
	sfx_click.play()
	
	var labels_child_count: int = labels.get_child_count()
	if current_labels < labels_child_count:
		labels_pos.x += get_viewport().size.x
		current_labels = labels_pos.x / get_viewport().size.x + 1
		sfx_slide.play()
		
		# when reached last "page"
		if current_labels == labels_child_count:
			continue_button_text.text = "Start"
	
	else:
		Global.did_tutorial = true
		get_tree().change_scene("res://scenes/SceneManager.tscn")
