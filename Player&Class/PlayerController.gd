extends Node2D

class_name Player

var gmc:Node2D
var camera:Camera2D

#life
var player_life_bar
var max_life:int
var life:int

#power
var player_power_bar
var max_power:int
var power:int

#dices
var dice:int
var rng = RandomNumberGenerator.new()

#attack
var current_weapon_damage:int
var current_type_damage:String
var enemy_select:Node2D
var can_select_enemy:bool = false

#defence
var is_defending:bool = false
var current_defence:int


#attack
func attack_button_down():
	if gmc.current_room == "Combat" && gmc.turn_state == gmc.turn.PLAYER:
		can_select_enemy = true
		print("selecione")
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

#defence
func defence_button_down():
	if gmc.current_room == "Combat" && gmc.turn_state == gmc.turn.PLAYER:
		is_defending = true
		gmc.change_turn()

#take damage
func take_damage(dam:int):
	if is_defending == false:
		life -= dam
	else:
		life -= (dam - current_defence)
	player_life_bar.value = life
	var camera = get_tree().get_first_node_in_group("Camera")
	camera.aply_shake(2)
	print(life)
	if life <= 0:
		queue_free()

#reload player stats
func load_stats():
	var data = SavePlayerStats.stored_data
	if data:
		max_life = data.get("player_max_hp")
		life = data.get("player_hp")
		max_power = data.get("player_max_power")
		power = data.get("player_power")
		current_weapon_damage = data.get("current_weapon")
		current_defence = data.get("current_defence")
