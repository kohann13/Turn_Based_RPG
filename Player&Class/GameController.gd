extends Node2D

var player:Node2D

@export var possibles_class_to_spawn:Array[PackedScene]
@onready var spawn_point_pl = $PlayerSpawnPoint
var player_class:String

#current dungeon level
var dungeon_level:int = 3
var rooms_completed:int = 0

#start game
@export var possible_rooms:Array[PackedScene]
var current_room:String

#turn system
enum turn {PLAYER,ENEMY,CHANGETURN,WIN,LOST}
var turn_state:turn
@onready var change_turn_ui = $changeTurnEffect
@onready var change_turn_anim = $changeTurnEffect/AnimationPlayer

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
			instance_pl.position = spawn_point_pl.position
		"warrior":
			var instance_pl = possibles_class_to_spawn[1].instantiate()
			add_child(instance_pl)
			instance_pl.position = spawn_point_pl.position

func change_turn():
	turn_state == turn.CHANGETURN
	await get_tree().create_timer(1).timeout
	if turn_state == turn.PLAYER:
			#play animation to change turn
		change_turn_ui.visible = true
		change_turn_anim.play("changeTurnToEnemy")
		await get_tree().create_timer(2).timeout
		change_turn_ui.visible = false
		change_turn_anim.play("RESET")
		
		#change turn
		turn_state = turn.ENEMY
		print("enemy turn")
		enemy_turn()
	elif turn_state == turn.ENEMY:
		#play animation to change turn
		change_turn_ui.visible = true
		change_turn_anim.play("changeTurnToEnemy")
		await get_tree().create_timer(2).timeout
		change_turn_ui.visible = false
		change_turn_anim.play("RESET")
		
		#change turn
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
			await get_tree().create_timer(1.5).timeout
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
		player.queue_free()

func save_player_stats():
	SavePlayerStats.save_stats({
			"player_max_hp":player.max_life,
			"player_hp":player.life,
			"player_max_power":player.max_power,
			"player_power":player.power,
			"current_weapon":player.current_weapon_damage,
			"current_defence":player.current_defence
		})
