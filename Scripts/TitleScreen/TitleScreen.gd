extends Control


func _ready():
	pass


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/root.tscn")


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen/CreditsMenu/CreditsMenu.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
