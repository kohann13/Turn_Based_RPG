extends Node2D

@onready var anim = $AnimationPlayer

var gmc:Node2D
var player:Node2D

#life
@onready var enemy_life_bar = $UI/life_bar
var max_life:int = 15
var life:int = 15

#select enemy
@onready var enemy_selection = $UI/EnemySelection
var can_select:bool = false
var mouse_enter:bool = false

#attack:
var damage:int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gmc = get_tree().get_first_node_in_group("GameController")
	gmc.enemys_in_scene.append(self)
	
	enemy_life_bar.max_value = max_life
	enemy_life_bar.value = life
	
	anim.play("Idle")


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
		enemy_selection.visible = true
		enemy_selection.rotation += 0.01
	else:
		enemy_selection.visible = false
		enemy_selection.rotation = 0
func _on_area_2d_mouse_entered() -> void:
	mouse_enter = true
	enemy_selection.scale = Vector2(1.2,1.2)
func _on_area_2d_mouse_exited() -> void:
	mouse_enter = false
	enemy_selection.scale = Vector2(1,1)

func attack():
	player = get_tree().get_first_node_in_group("Player")
	player.take_damage(damage)
	print("recebeu dano")

func take_damage(dam:int):
	life -= dam
	enemy_life_bar.value = life
	
	if life <= 0:
		gmc.enemys_in_scene.erase(self)
		queue_free()
