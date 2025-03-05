extends Player

@onready var anim = $AnimationPlayer

#actions UI
@onready var attack_button_spr = $UI/Actions/AttackButton/AttackButtonSpr
@onready var defence_button_spr = $UI/Actions/DefenceButton/DefenceButtonSpr
@onready var ability_button_spr = $UI/Actions/AbilityButton/AbilityButtonSpr

#life UI
@onready var life_bar = $UI/LifeBarUI/LifeBar
@onready var power_bar = $UI/LifeBarUI/PowerBar

#text box UI
@onready var text = $UI/TextBox/text

#start class stats
func _init() -> void:
	max_life = 15
	life = 15
	max_power = 5
	power = 5
	current_weapon_damage = 5
	current_defence = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load player current stats
	load_stats()
	
	#set variables
	gmc = get_tree().get_first_node_in_group("GameController")
	player_life_bar = life_bar
	player_power_bar = power_bar
	
	life_bar.max_value = max_life
	life_bar.value = life
	power_bar.max_value = max_power
	power_bar.value = power
	
	anim.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack()


#actions
func _on_attack_button_button_down() -> void:
	attack_button_down()
func _on_defence_button_button_down() -> void:
	defence_button_down()
func _on_ability_button_button_down() -> void:
	#ability barbarian test
	if gmc.current_room == "Combat" && gmc.turn_state == gmc.turn.PLAYER:
		life += 2
		life_bar.value = life
		print(life)
		
		gmc.change_turn()

#select buttons UI
func _on_attack_button_mouse_entered() -> void:
	attack_button_spr.scale = Vector2(1.1,1.1)
	attack_button_spr.frame = 1
	text.text = "roll d6 +atk"
func _on_defence_button_mouse_entered() -> void:
	defence_button_spr.scale = Vector2(1.1,1.1)
	defence_button_spr.frame = 1
	text.text = "roll d6 +def"
func _on_ability_button_mouse_entered() -> void:
	ability_button_spr.scale = Vector2(1.1,1.1)
	ability_button_spr.frame = 1
	text.text = "restory +2hp"

func _on_attack_button_mouse_exited() -> void:
	attack_button_spr.scale = Vector2(1,1)
	attack_button_spr.frame = 0
	text.text = ""
func _on_defence_button_mouse_exited() -> void:
	defence_button_spr.scale = Vector2(1,1)
	defence_button_spr.frame = 0
	text.text = ""
func _on_ability_button_mouse_exited() -> void:
	ability_button_spr.scale = Vector2(1,1)
	ability_button_spr.frame = 0
	text.text = ""
