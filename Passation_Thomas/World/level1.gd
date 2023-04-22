extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"chain countainer".visible = 0
	$"chain countainer2".visible = 0
	$"chain countainer3".visible = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $musket.used :
		$"chain countainer".visible = 1
	if $musket2.used :
		$"chain countainer2".visible = 1
	if $musket3.used :
		$"chain countainer3".visible = 1
