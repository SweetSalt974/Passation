extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var state_machine = anim_tree["parameters/playback"]
@export var acc = 20
@export var max_speed = 100
@export var jump_height : float = 30
@export var jump_time_to_peak : float = 0.3
@export var jump_time_to_fall : float = 0.3

@onready var jump_velocity = (-2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity = (2.0 * jump_height) / (jump_time_to_peak ** 2) 
@onready var fall_gravity = (2.0 * jump_height) / (jump_time_to_fall ** 2)
var last_direction =1
var is_jumping : bool = false
@export_range(1,5) var fast_fall_coef = 500
var fast_falling : bool = false
var is_dashing : bool = false
var finished_dashing : bool = false
@export_range(0,1) var timer = 0.1
var local_timer = 0
var theta = 0
func _ready():
	$idle.visible = 1
	$walk.visible = 0
	$jump.visible = 0

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	if (Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()
	if not is_on_floor():
		if (is_jumping) && !(is_dashing):
			velocity.y += jump_gravity * delta
			if (velocity.y<0.0):
				is_jumping = false
		if !(is_jumping) && !(is_dashing):
			if !(fast_falling):
				velocity.y += fall_gravity * delta
			elif (fast_falling):
				velocity.y += fall_gravity * delta * fast_fall_coef
		if (is_dashing):
			velocity.y += 0
	if (is_on_floor()):
		fast_falling = false
		is_jumping = false
	if (Input.is_action_just_pressed("jump") and is_on_floor() && !(is_dashing)):
		velocity.y = jump_velocity 
		state_machine.travel("jump")
		is_jumping = true
	if Input.is_action_just_pressed("down") and !(is_on_floor()):
		fast_falling = true
#	print(rotation)
#	if (rotation_degrees > 1):
#		rotation_degrees -= 1
#	else :
##		self.rotation = 0
#	if (velocity.x == 0) :
#		$jump.scale.x = last_direction
#	if (velocity.x > 0) :
#		$jump.scale.x = 1
#	if (velocity.x < 0) :
#		$jump.scale.x = -1
	if !(is_dashing):
		if direction:
			$walk.scale.x = direction
			if ((abs(velocity.x)) < max_speed):
				velocity.x += direction * acc
			else :
				if (direction == 1):
					velocity.x = min(max_speed, velocity.x + acc)
				if (direction == -1):
					velocity.x = max(-max_speed, velocity.x - acc)
			if (is_on_floor() && !(is_jumping)):
				state_machine.travel("walk")
			last_direction = direction
		else:
#			velocity.x = move_toward(velocity.x, 0, speed)
			if abs(velocity.x) > 50 :
				if velocity.x > 0:
					velocity.x -= delta * max_speed*5
					$jump.scale.x = 1
				if velocity.x < 0:
					velocity.x += delta * max_speed*5
					$jump.scale.x = -1
			else:
				velocity.x = 0
				$jump.scale.x = last_direction
			$idle.scale.x = last_direction
			if (is_on_floor()&& !(is_jumping)):
				state_machine.travel("idle")
				
	# Dashing 
#	print(get_angle_to(get_global_mouse_position()))
	if (is_dashing && !(finished_dashing)):
		theta = get_angle_to(get_global_mouse_position())
		velocity.x = cos(theta)*300
		if (0 > theta && theta >-3.15):
			var coef = get_global_mouse_position().distance_to(global_position)
			if (-0.9 > theta && theta > -2.3):
				print(coef)
				velocity.y = sin(theta)*abs(170 + coef)
			else :
				velocity.y = sin(theta)*330
		else :
			velocity.y = sin(theta)*300
		finished_dashing = true
		is_jumping = false
		
	if (finished_dashing):
		local_timer += delta
		if (local_timer > timer ):
			is_dashing = false
			finished_dashing = false 
			local_timer = 0
	move_and_slide()
