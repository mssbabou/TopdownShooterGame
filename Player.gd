extends AnimatedSprite2D

var max_speed = 75
var acceleration = 250
var deceleration = 200
var angular_speed = 10.0

var velocity = Vector2()
var target_angle = 0.0

func _ready():
	target_angle = rotation

func _process(delta):
	var target_velocity = Vector2()
	var is_moving = false
	
	if Input.is_action_pressed("Move_Right"):
		target_velocity.x += 1
		is_moving = true
	if Input.is_action_pressed("Move_Left"):
		target_velocity.x -= 1
		is_moving = true
	if Input.is_action_pressed("Move_Down"):
		target_velocity.y += 1
		is_moving = true
	if Input.is_action_pressed("Move_Up"):
		target_velocity.y -= 1
		is_moving = true

	# Normalize and store target angle
	if is_moving:
		target_velocity = target_velocity.normalized() * max_speed
		target_angle = target_velocity.angle() + deg_to_rad(90)

	# Accelerate or decelerate
	if is_moving:
		var accel_dir = (target_velocity - velocity).normalized()
		velocity += accel_dir * acceleration * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		if velocity.length() > 0:
			var decel_dir = -velocity.normalized()
			velocity += decel_dir * deceleration * delta
			if velocity.length() < 1:
				velocity = Vector2()

	# Rotate only if moving
	if is_moving:
		# Wrap angle to [-PI, PI]
		var raw_diff = fmod(target_angle - rotation + PI, 2 * PI)
		if raw_diff < 0:
			raw_diff += 2 * PI
		var angle_diff = raw_diff - PI

		if abs(angle_diff) > 0.01:
			var rotation_direction = sign(angle_diff)
			rotation += rotation_direction * angular_speed * delta
			# Clamp rotation if we overshoot
			if abs(angle_diff) < angular_speed * delta:
				rotation = target_angle

	position += velocity * delta

@export var bullet_scene: PackedScene  # Drag & drop Bullet.tscn in the Inspector

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()
		
func shoot():
	bullet_scene.instantiate()
