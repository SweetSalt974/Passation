extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var state_machine = anim_tree["parameters/playback"]
@export var speed = 150
@export var acc = 1.2
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
# Get the gravity from the project settings to be synced with RigidBody nodes.
var jump_acceleration = 1.0
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
	if (Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()
	if (finished_dashing):
		local_timer += delta
		if (local_timer > timer ):
			is_dashing = false
			finished_dashing = false 
			local_timer = 0
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
	if Input.is_action_just_pressed("jump") and is_on_floor() && !(is_dashing):
		$jump.scale.x = last_direction
		velocity.y = jump_velocity 
		state_machine.travel("jump")
		is_jumping = true
	if Input.is_action_just_pressed("down") and !(is_on_floor()):
		fast_falling = true
	var direction = Input.get_axis("left", "right")
	if !(is_dashing):
		if direction:
			$walk.scale.x = direction
			velocity.x = direction * speed
			if (is_on_floor() && !(is_jumping)):
				state_machine.travel("walk")
			last_direction = direction
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			$idle.scale.x = last_direction
			if (is_on_floor()&& !(is_jumping)):
				state_machine.travel("idle")
	if (is_dashing && !(finished_dashing)):
		theta = get_angle_to(get_global_mouse_position())
		velocity.x = cos(theta)*300
		if (theta < -1.2 ):
			velocity.y = sin(theta)*200
		else :
			velocity.y = sin(theta)*300
		finished_dashing = true
		is_jumping = false
	move_and_slide()
