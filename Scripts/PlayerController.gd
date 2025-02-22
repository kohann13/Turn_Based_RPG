extends Node2D

var gmc:Node2D

#life
var life:int = 10

#dices
var dice:int
var rng = RandomNumberGenerator.new()

#attack
var current_weapon_damage:int = 5
var current_type_damage:String
var enemy_select:Node2D
var can_select_enemy:bool = false

#defence
var current_defence:int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#save system
	var data = SavePlayerStats.stored_data
	if data:
		life = data.get("player_hp")
		current_weapon_damage = data.get("current_weapon")
		current_defence = data.get("current_defence")
	
	gmc = get_tree().get_first_node_in_group("GameController")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack()
	

func _on_attack_button_button_down() -> void:
	if gmc.current_room == "Combat" && gmc.turn_state == gmc.turn.PLAYER:
		can_select_enemy = true

func attack():
	if enemy_select != null:
		can_select_enemy = false
		
		dice = rng.randf_range(1,7)
		print(dice)
		dice += current_weapon_damage
		print(dice)
		enemy_select.take_damage(dice)
		
		dice = 0
		enemy_select = null
		gmc.change_turn()

func take_damage(dam:int):
	life -= dam
	if life <= 0:
		queue_free()
