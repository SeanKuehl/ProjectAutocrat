extends CanvasLayer


func _ready():
	pass


func HideMyStuff():
	$Panel.hide()
	$YouWonLabel.hide()
	$DoneButton.hide()

func ShowMyStuff():
	$Panel.show()
	$YouWonLabel.show()
	$DoneButton.show()


func _on_DoneButton_pressed():
	get_tree().quit()



