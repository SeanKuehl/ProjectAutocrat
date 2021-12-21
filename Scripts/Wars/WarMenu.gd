extends CanvasLayer

signal UserDonwWithWarMenu()


func _ready():
	pass


func ShowWarStarted(war):
	var detailLabelText = war.GetWarName()+" has declared war on us. They have "+str(war.GetMilitaryPoints())+". We estimate the was will take "+str(war.GetTurnsLeft())+" if we have as many military points as them."
	$WarDetailLabel.text = detailLabelText

func ShowWarReport(war):
	var detailLabelText = "Some of our people's approval has declined,  we think the war will last "+str(war.GetTurnsLeft())+" more turns."
	$WarDetailLabel.text = detailLabelText

func ShowEndOfWar(war):
	var detailLabelText = "Our war with "+str(war.GetWarName())+" is over, thanks to your military prowess."
	$WarDetailLabel.text = detailLabelText

func HideMyStuff():
	$Panel.hide()
	$WarDetailLabel.hide()
	$DoneButton.hide()

func ShowMyStuff():
	$Panel.show()
	$WarDetailLabel.show()
	$DoneButton.show()


func _on_DoneButton_pressed():
	emit_signal("UserDonwWithWarMenu")
