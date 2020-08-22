extends KinematicBody2D

signal door_touch
signal player_death

enum {LEFT = -1, RIGHT = 1}
const SPEED = 128
const JUMPMAX = -300
const GRAV = 10
const MAXGRAV = 500
const JUMPSPEED = -200
const SPEEDMULT = 8
const UP_DIR = Vector2(0,-1)

var currSpeed = 0
var currJump = 0
var motion = Vector2()
var startPosition = Vector2()
var orientation = -1
var prevOrientation = -1
var jumping = false
var falling = false
var in_cannon = false
var is_shot = false
var is_dead = false
var allow_movement = true
var allow_enter_cannon = true
var allow_input = true
var death_counter = 0

var cannonVector = Vector2()
var cannonPlayerMoveModifier = 0
var cannonPower = 0

func processMovementInput(delta):
	
	if is_shot:
		cannonPlayerMoveModifier = currSpeed/2
	else:
		cannonPlayerMoveModifier = 0

	if in_cannon:
		jumping = false
		falling = false
		motion = Vector2(0,0)
		currSpeed = 0
	#lateral movement
	elif allow_input:
		if Input.is_action_pressed("ui_left"):
			prevOrientation = orientation
			orientation = -1
			$Sprite.flip_h = false
			calcMotion()
		elif Input.is_action_pressed("ui_right"):
			prevOrientation = orientation
			orientation = 1
			$Sprite.flip_h = true
			calcMotion()
		elif not is_shot: #this may need to be refined
			#TODO: add gradual slow down
			motion.x = 0
			currSpeed = 0

	if is_on_floor():
		jumping = false
		falling = false
		is_shot = false
		rotation_degrees = 0
		if Input.is_action_pressed("jump"):
			if currJump < 3:
				currJump += 1
				jumping = true
				falling = false
		if currJump == 3 or jumping:
			motion.y = currJump * -75 + JUMPSPEED
			currJump = 0
	if jumping and not Input.is_action_pressed("jump"):
		falling = true
			
	playMovementAnimation()

func playMovementAnimation():
	if not $AnimationPlayer.current_animation == "cannon_shot":
		rotation_degrees = 0
		if motion.x != 0 and is_on_floor():
			$AnimationPlayer.play("walk")
		elif motion.y < 0:
			$AnimationPlayer.play("jumping")
		elif falling or Input.is_action_pressed("ui_down"):
			$AnimationPlayer.play("down")
		else:
			$AnimationPlayer.play("idle")


func calcMotion():
	if prevOrientation != orientation:
		currSpeed = 0
	if(currSpeed < SPEED):
		currSpeed += SPEEDMULT
		print(currSpeed)
	motion.x = orientation * currSpeed + (-1*orientation*cannonPlayerMoveModifier)

func player_enter_cannon():
	if allow_enter_cannon:
		visible = false
		in_cannon = true
	
func cannon_shot(cV, cPos, cPower):
	cannonVector = cV
	position = cPos
	cannonPower = cPower
	in_cannon = false
	visible = true
	is_shot = true
	falling = true
	allow_input = false
	allow_enter_cannon = false
	$CannonMovementTimer.start()
	#$AnimationPlayer.play("cannon_shot")
	$CannonSound.play(0.0)
	motion = Vector2(cannonVector.x*cannonPower,cannonVector.y*cannonPower)

func check_tile_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			if collision.collider is TileMap:
				# Find the character's position in tile coordinates
				var tile_pos = collision.collider.world_to_map(position)
				# Find the colliding tile position
				tile_pos -= collision.normal
				# Get the tile id
				var tile_id = collision.collider.get_cellv(tile_pos)
				
				var tile_name = collision.collider.tile_set.tile_get_name(tile_id)

				if (not is_dead) and (tile_name == "spikes" or tile_name == "lava"):
					emit_signal("player_death")
					death()
				elif tile_name == "door":
					emit_signal("door_touch")

func death():
	$DeathTimer.start()
	is_dead = true
	allow_enter_cannon = false
	$Sprite.visible = false
	$CannonCollisonDetector/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$DeathParticles.emitting = true
	$DeathSound.play(0.0)
	death_counter += 1


func _physics_process(delta):
	if motion.y < MAXGRAV:
		motion.y += GRAV
	
	#$DeathCounter.text = death_counter
	
	if is_dead or not allow_movement:
		jumping = false
		falling = false
		motion = Vector2(0,0)
		currSpeed = 0
	else:
		processMovementInput(delta)
	
	print("motion: ",motion)
	motion = move_and_slide(motion, UP_DIR)
	
	if not is_dead:
		check_tile_collisions()

func _on_DeathTimer_timeout():
	position = startPosition
	$Sprite.visible = true
	is_dead = false
	$CannonCollisonDetector/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	allow_enter_cannon = true


func _on_CannonMovementTimer_timeout():
	allow_movement = true
	allow_enter_cannon = true
	allow_input = true
