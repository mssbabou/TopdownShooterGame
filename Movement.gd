extends AnimatedSprite2D

# Movement speed
var max_speed = 75  # Maximum speed the player can reach
var acceleration = 250  # Rate at which the player accelerates
var deceleration = 200  # Rate at which the player slows down
var velocity = Vector2()  # Current velocity of the player
@onready var player: AnimatedSprite2D = $"."

func _process(delta):
	# Get input from the player (WASD or arrow keys)
	var target_velocity = Vector2()  # Reset target velocity
	
	if Input.is_action_pressed("Move_Right"):
		target_velocity.x += 1
		player.flip_h = false
	if Input.is_action_pressed("Move_Left"):
		target_velocity.x -= 1
		player.flip_h = true
	if Input.is_action_pressed("Move_Down"):
		target_velocity.y += 1
	if Input.is_action_pressed("Move_Up"):
		target_velocity.y -= 1

	# Normalize the target velocity to ensure consistent speed
	if target_velocity.length() > 0:
		target_velocity = target_velocity.normalized() * max_speed

	# Accelerate towards the target velocity when there's input
	if target_velocity != Vector2():
		var acceleration_direction = (target_velocity - velocity).normalized()
		velocity += acceleration_direction * acceleration * delta
		# Clamp the velocity to the max speed
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		# Decelerate when no input is given (velocity slows down gradually)
		if velocity.length() > 0:
			var deceleration_direction = -velocity.normalized()
			velocity += deceleration_direction * deceleration * delta
			# Stop the velocity if it's very close to zero
			if velocity.length() < 1:
				velocity = Vector2()

	# Update the position
	position += velocity * delta
