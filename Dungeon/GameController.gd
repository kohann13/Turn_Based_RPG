extends Node2D

var player:Node2D

@export var possibles_class_to_spawn:Array[PackedScene]
var player_class:String

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
	load_infos()
	start_game()
	
	turn_state = turn.PLAYER
	player = get_tree().get_first_node_in_group("Player")
	print(current_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	win()
	lost()


func load_infos():
	var data = SaveGameController.stored_data
	if data:
		player_class = data.get("player_class")
func start_game():
	#instance room
	var instance_room = possible_rooms.pick_random().instantiate()
	instance_room.level_room = dungeon_level
	add_child(instance_room)
	current_room = instance_room.type_room
	
	#instance player
	print(player_class)
	match player_class:
		"barbarian":
			var instance_pl = possibles_class_to_spawn[0].instantiate()
			add_child(instance_pl)
			instance_pl.position = Vector2(192,176)
		"warrior":
			var instance_pl = possibles_class_to_spawn[1].instantiate()
			add_child(instance_pl)
			instance_pl.position = Vector2(192,176)

func change_turn():
	if turn_state == turn.PLAYER:
		turn_state = turn.ENEMY
		print("enemy turn")
		enemy_turn()
	elif turn_state == turn.ENEMY:
		turn_state = turn.PLAYER
		if player.is_defending == true:
			player.is_defending = false
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
		save_player_stats()
		get_tree().reload_current_scene()

func lost():
	if current_room == "Combat" && player == null && turn_state != turn.LOST:
		turn_state = turn.LOST
		print("game over")

func save_player_stats():
	SavePlayerStats.save_stats({
			"player_hp":player.life,
			"current_weapon":player.current_weapon_damage,
			"current_defence":player.current_defence
		})
