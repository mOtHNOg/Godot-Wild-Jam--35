extends KinematicBody2D
class_name MovingObject

export var max_velocity: float
export var accel_speed: float
export var decel_speed: float

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	move_and_slide(velocity)
