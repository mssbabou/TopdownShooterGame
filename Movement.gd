extends AnimatedSprite2D

# Movement speed
var max_speed = 100  # Maximum speed the player can reach
var acceleration = 400  # Rate at which the player accelerates
var deceleration = 200  # Rate at which the player slows down
var velocity = Vector2()  # Current velocity of the player
@onready var player: AnimatedSprite2D = $"."

func _process(delta):
	# Get input from the player (WASD or arrow keys)
	var target_velocity = Vector2()  # Reset target velocity
	
	var direction = Input.get_axis("Move_Left", "Move_Right")

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

	# Normalize the target velocity to ensure consistent speed in all directions
	if target_velocity.length() > 0:
		target_velocity = target_velocity.normalized() * max_speed
	# Acceleration: Increase speed towards the target velocity
	if velocity != target_velocity:
		var acceleration_direction = (target_velocity - velocity).normalized()
		velocity += acceleration_direction * acceleration * delta
	else:
		# Deceleration: Slow down when no input is given
		if velocity.length() > 0:
			var deceleration_direction = -velocity.normalized()
			velocity += deceleration_direction * deceleration * delta

	# Move the sprite
	position += velocity * delta
