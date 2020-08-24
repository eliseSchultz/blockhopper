extends CanvasLayer

var death_counter = 0
var player_vars
var time = 0.0
var started = false

func _ready():
	player_vars = get_node("/root/PlayerVariables")
	death_counter = player_vars.player_death_count

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DeathCounter.text = str(death_counter)
	if started:
		time += delta


func _on_Player_player_death():
	death_counter += 1
	print("DEATH COUNTER" + str(death_counter))
	player_vars.player_death_count = death_counter
