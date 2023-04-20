extends Node2D
@export var used : bool = false
@onready var animate = $AnimationPlayer
var player = null
var mouse_in : bool = false

func _ready():
	animate.play("spinning")
	$outline.modulate.a = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (mouse_in && player != null && !(used)):
		if (Input.is_action_just_pressed("shoot")):
			player.velocity.x = 600
			player.velocity.y = 0
			player.is_dashing = true
			player.is_jumping = false
			used = true
			$outline.visible = 0

func _on_visibility_body_entered(body):
	player = body
	$outline.modulate.a = 1

func _on_visibility_body_exited(body):
	player = null
	$outline.modulate.a = 0.3


func _on_detection_mouse_entered():
	mouse_in = true
