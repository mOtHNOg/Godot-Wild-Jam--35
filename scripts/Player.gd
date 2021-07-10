#extends MovingObject
#
#var movement_direction: Vector2 = Vector2.ZERO
#
#func _physics_process(delta):
#	movement_direction = Vector2(
#		Input.get_action_strength("right") - Input.get_action_strength("left"),
#		Input.get_action_strength("down") - Input.get_action_strength("up")
#	).normalized()
#
#	if movement_direction != Vector2.ZERO:
#		velocity = lerp(velocity, movement_direction * max_velocity, accel_speed * delta)
#	else:
#		velocity = lerp(velocity, Vector2.ZERO, decel_speed * delta)
