extends Node2D

var type_room:String = "Combat"
var level_room:int

#spawn enemys
@export var possible_enemys:Array[PackedScene]
@onready var spawners = [$SpawnPoint1,$SpawnPoint2,$SpawnPoint3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()

func spawn():
	match level_room:
		1:
			var instance_enemy = possible_enemys.pick_random().instantiate()
			add_child(instance_enemy)
			instance_enemy.position = spawners[0].global_position
		2:
			var rand = randf_range(0,2)
			for I in rand:
				var instance_enemy = possible_enemys.pick_random().instantiate()
				add_child(instance_enemy)
				instance_enemy.position = spawners[I].global_position
		3:
			var rand = randf_range(1,3)
			for I in rand:
				var instance_enemy = possible_enemys.pick_random().instantiate()
				add_child(instance_enemy)
				instance_enemy.position = spawners[I].global_position
