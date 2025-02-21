extends Node2D

var player:Node2D

#current dungeon level
var dungeon_level:int = 1
var rooms_completed:int = 0

#start game
@export var possible_rooms:Array[PackedScene]
var current_room:String

#turn system
enum turn {PLAYER,ENEMY,WIN,LOST}
var turn_state:turn

#enemys
var enemys_in_scene:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()
	
	turn_state = turn.PLAYER
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	win()
	lost()

func start_game():
	var instance_room = possible_rooms.pick_random().instantiate()
	instance_room.level_room = dungeon_level
	add_child(instance_room)
	current_room = instance_room.type_room

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
	if current_room == "Combat" && enemys_in_scene.size() <= 0 && turn_state != turn.WIN:
		turn_state = turn.WIN
		print("Win")
		get_tree().reload_current_scene()

func lost():
	if current_room == "Combat" && player == null && turn_state != turn.LOST:
		turn_state = turn.LOST
		print("game over")
