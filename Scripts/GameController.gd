extends Node2D

var player:Node2D

#turn system
enum turn {PLAYER,ENEMY,WIN,LOST}
var turn_state:turn

#enemys & spawn enemys
var enemys_in_scene:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_state = turn.PLAYER
	
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	win()
	lost()

func change_turn():
	if turn_state == turn.PLAYER:
		turn_state = turn.ENEMY
		print("enemy turn")
		enemy_turn()
	elif turn_state == turn.ENEMY:
		turn_state = turn.PLAYER
		print("player turn")

func enemy_turn():
	await get_tree().create_timer(1).timeout
	if turn_state == turn.ENEMY:
		for I in enemys_in_scene.size():
			if turn_state == turn.LOST:
				break
			enemys_in_scene[I].attack()
			await get_tree().create_timer(1).timeout
		if player != null:
			change_turn()

func win():
	if enemys_in_scene.size() <= 0 && turn_state != turn.WIN:
		turn_state = turn.WIN
		print("Win")

func lost():
	if player == null && turn_state != turn.LOST:
		turn_state = turn.LOST
		print("game over")
