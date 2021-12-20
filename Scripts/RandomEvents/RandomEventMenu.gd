extends CanvasLayer



signal UserDoneWithRandomEventMenu()


func HideMyStuff():
	$Panel.hide()
	$EventNameLabel.hide()
	$EventDescLabel.hide()
	$EventValuesLabel.hide()
	$OKButton.hide()

func ShowMyStuff():
	$Panel.show()
	$EventNameLabel.show()
	$EventDescLabel.show()
	$EventValuesLabel.show()
	$OKButton.show()




func ShowEvent(event):
	#maybe tell the user which caste is getting the approval change if needed

	$EventNameLabel.text = event.GetName()
	$EventDescLabel.text = event.GetDescription()

	var values = event.GetValues()
	var labelText = "Treasury change: "+str(values[0])+", caste approval change: "+str(values[1])+", military points change: "+str(values[2])+", "+" police points change: "+str(values[3])
	$EventValuesLabel.text = labelText




func _on_OKButton_pressed():

	emit_signal("UserDoneWithRandomEventMenu")
