extends Control


func _ready():
	pass


func _on_DoneButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
