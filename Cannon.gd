extends Node2D


export var identification = ""
export var cannonPower = 0
export var cannonType = "" #must be the name of the animation or static

var orientation = Vector2(0,-1)

var angle_o = {
	0:Vector2(0,-1), 
	45:Vector2(1,-1), 
	90:Vector2(1,0), 
	135:Vector2(1,1),
	180:Vector2(0,1),
	225:Vector2(-1,1),
	270:Vector2(-1,0),
	315:Vector2(-1,-1),
}


func set_params(type, id, power=600, angle=0):
	$Area2D.rotation_degrees = angle
	cannonPower = power
	cannonType = type
	identification = id

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cannonType != "static" or cannonType != "":
		$AnimationPlayer.play(cannonType)
	
	orientation = angle_o[int($Area2D.rotation_degrees)]


func _on_Cannon_body_entered(body):
	if body.has_method("player_enter_cannon"):
		body.player_enter_cannon()

