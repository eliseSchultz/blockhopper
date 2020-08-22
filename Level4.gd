extends Node2D

signal collided

var currCannon
var currCannonPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_params(type, id, power=600, angle=0)
	$Cannon.set_params("static", "c1", 400, 270)
	$Cannon2.set_params("move_static_v", "c2", 300, 315)
	$Cannon3.set_params("move_static_v", "c3", 700, 270)

	
	$Player.startPosition = $Player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.in_cannon:
		if Input.is_action_just_pressed("jump"):
			#cannon_shot(cV, cPos, cPower)
			$Player.cannon_shot(currCannon.orientation, currCannonPosition, currCannon.cannonPower)


func _on_CannonCollisonDetector_area_entered(area):
	currCannon = area.get_parent()
	currCannonPosition = currCannon.position + (area.position *-1)


func _on_Player_door_touch():
	get_tree().change_scene("res://Level1.tscn")
