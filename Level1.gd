extends Node2D

signal collided

var currCannon

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_params(type, id, power=600, angle=0)
	$Cannon.set_params("static", "c1")
	$Cannon2.set_params("static", "c2", 400, 90)
	$Cannon3.set_params("static", "c3", 400, 225)
	$Cannon4.set_params("static", "c4", 200, 45)
	
	$Player.startPosition = $Player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.in_cannon:
		if Input.is_action_just_pressed("jump"):
			#cannon_shot(cV, cPos, cPower)
			$Player.cannon_shot(currCannon.orientation, currCannon.position, currCannon.cannonPower)


func _on_CannonCollisonDetector_area_entered(area):
	currCannon = area.get_parent()


func _on_Player_door_touch():
	get_tree().change_scene("res://Level2.tscn")
