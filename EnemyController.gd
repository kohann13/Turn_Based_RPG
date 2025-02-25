extends Node2D

var gmc:Node2D
var player:Node2D

#life
var life:int = 10

#select enemy
var can_select:bool = false
var mouse_enter:bool = false

#attack:
var damage:int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gmc = get_tree().get_first_node_in_group("GameController")
	
	
	gmc.enemys_in_scene.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select()
	

func select():
	player = get_tree().get_first_node_in_group("Player")
	if player!=null:
		can_select = player.can_select_enemy
	if mouse_enter == true && can_select == true && Input.is_action_just_pressed("moule_leaft"):
		player.enemy_select = self
		can_select = false
	
	if can_select == true:
		pass
func _on_area_2d_mouse_entered() -> void:
	mouse_enter = true
func _on_area_2d_mouse_exited() -> void:
	mouse_enter = false

func attack():
	player = get_tree().get_first_node_in_group("Player")
	player.take_damage(damage)
	print("recebeu dano")

func take_damage(dam:int):
	life -= dam
	
	if life <= 0:
		gmc.enemys_in_scene.erase(self)
		queue_free()
