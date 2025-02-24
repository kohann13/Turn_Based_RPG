extends Node

var selected_class:String

func _on_barbarian_button_down() -> void:
	selected_class = "barbarian"
	change_scene()

func _on_warrior_button_down() -> void:
	selected_class = "warrior"
	change_scene()

func change_scene():
	SaveGameController.save_infos({
		"player_class":selected_class
	})
	
	get_tree().change_scene_to_file("res://cenas/game.tscn")
