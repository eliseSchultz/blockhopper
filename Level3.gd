extends Node2D

signal collided

var currCannon
var currCannonPosition
var currArea

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_params(type, id, power=600, angle=0)
	$Cannon.set_params("static", "c1", 300)
	$Cannon2.set_params("move_rotate", "c2", 400)
	$Cannon3.set_params("static", "c3", 300, 90)
	$Cannon4.set_params("move_static_h", "c4", 200, 180)
	$Cannon5.set_params("move_static_h", "c5", 200, 180)
	$Cannon6.set_params("counter_rotate", "c6", 200)
	$Cannon7.set_params("rotate", "c7", 200)
	$Cannon8.set_params("rotate", "c8", 300)
	$Cannon9.set_params("move_static_v_half", "c9", 300, 270)
	
	$Player.startPosition = $Player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.in_cannon:
		currCannonPosition = currCannon.position + currArea.position
		$Player.position = currCannonPosition
		if Input.is_action_just_pressed("jump"):
			#cannon_shot(cV, cPos, cPower)
			$Player.cannon_shot(currCannon.orientation, currCannonPosition, currCannon.cannonPower)


func _on_CannonCollisonDetector_area_entered(area):
	currCannon = area.get_parent()
	currArea = area



func _on_Player_door_touch():
	get_tree().change_scene("res://Level1.tscn")
