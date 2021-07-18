extends Area2D

# n
onready var tween = $Tween
onready var animation_player = $AnimationPlayer
onready var collision = $CollisionShape2D
onready var pick_up_sfx = $PickUpSFX
#onready var aura_parent: Node2D = Global.wall.toothbrush_aura_parent

const aura_object = preload("res://scenes/ToothbrushAura.tscn")

# position / animation related variables
onready var final_pos: Vector2 = get_viewport().size / 2
var at_final_pos: bool = false
var tween_time: float = 2 

export var offset: Vector2 = Vector2.ZERO

# control related variables
var mouse_entered: bool = false

func _ready() -> void:
	Global.toothbrush_exists = true
	
	# toothbrush will start out of screen and fly to the final pos
	tween.interpolate_property(self, "position", position, final_pos,
		tween_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func _process(_delta):
	if at_final_pos == true:
		position = final_pos + offset
	
	if mouse_entered == true and Input.is_action_just_pressed("click"):
		Global.has_toothbrush = true
		
		collision.set_deferred("disabled", true)
		
		pick_up_sfx.play()
		animation_player.play("Clicked")
		yield(animation_player, "animation_finished")
		
		queue_free()

func _on_Tween_tween_completed(_object, _key):
	at_final_pos = true
	animation_player.play("Idle")

func _on_Toothbrush_mouse_entered():
	mouse_entered = true

func _on_Toothbrush_mouse_exited():
	mouse_entered = false

# aura stuff is no longer being used (looked bad)

#func _on_AuraTimer_timeout():
#	var aura_instance = aura_object.instance()
#
#	aura_instance.global_position = global_position
#
#	aura_parent.add_child(aura_instance)
