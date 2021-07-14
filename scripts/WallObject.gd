extends KinematicBody2D
class_name WallObject

onready var sfx: Dictionary = {
	"pick_up" : $SFX/PickUp,
	"drop" : $SFX/Drop
}

var disabled: bool = false

var mouse_entered: bool = false
var mouse_clicked_inside_collision: bool = false

export var auto_apply_gravity: bool = true

var apply_gravity: bool = false

const gravity = 500

# velocity is applied only when not being dragged
var velocity: Vector2

func _ready():
	if auto_apply_gravity == true:
		apply_gravity = true

func _physics_process(delta):
	if disabled == true:
		input_pickable = false
	else:
		input_pickable = true
	
	if Input.is_action_just_pressed("left_click") and mouse_entered == true and Global.picked_up_wall_object == null and disabled == false:
		mouse_clicked_inside_collision = true
		Global.picked_up_wall_object = self
		
		sfx.pick_up.pitch_scale = rand_range(0.833, 1.167)
		sfx.pick_up.play()
	
	elif Input.is_action_just_released("left_click") and disabled == false:
		
		if Global.picked_up_wall_object != null:
			sfx.drop.pitch_scale = rand_range(0.833, 1.167)
			sfx.drop.play()
		
		mouse_clicked_inside_collision = false
		Global.picked_up_wall_object = null
	
	
	if mouse_clicked_inside_collision == true:
		apply_gravity = true
		velocity = Vector2.ZERO
	elif apply_gravity == true:
		velocity.y += gravity * delta
		move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity.y = 0
	
	# kill object when it goes off screen
	if global_position.y > 270:
		queue_free()
	
func _input(event):
	if event is InputEventMouseMotion and mouse_clicked_inside_collision == true:
		move_and_slide(event.relative * 60, Vector2.UP)

func _on_WallObject_mouse_entered():
	mouse_entered = true

func _on_WallObject_mouse_exited():
	mouse_entered = false
