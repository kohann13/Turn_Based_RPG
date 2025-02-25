extends Player

func _init() -> void:
	life = 10
	current_weapon_damage = 3
	current_defence = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_stats()
	gmc = get_tree().get_first_node_in_group("GameController")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack()


func _on_attack_button_button_down() -> void:
	attack_button_down()

func _on_defence_button_button_down() -> void:
	defence_button_down()

func _on_ability_button_button_down() -> void:
	if gmc.current_room == "Combat" && gmc.turn_state == gmc.turn.PLAYER:
		pass
