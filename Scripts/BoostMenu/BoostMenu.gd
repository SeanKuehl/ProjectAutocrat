extends CanvasLayer

var turnOfLastMilBoost = -1
var turnOfLastPolBoost = -1
var turnOfLastCasteBoost = -1

var currentTurn = -1

var casteNamesAndApprovals = []

signal BoostMilitary()
signal BoostPolice()
signal BoostCaste(casteName)
signal UserDoneWithBoostMenu()

func _ready():
	pass

func Init(passedStuff):
	#[milPopAndApprovalList[1],polPopAndApprovalList[1], casteNamesAndApprovals, turn]
	#I need caste names and approvals, military and police approvals too
	#also current turn, for comparison of things
	$MilitaryMessage.text = "Military approval: "+str(passedStuff[0])
	$PoliceMessage.text = "Police approval: "+str(passedStuff[1])

	casteNamesAndApprovals = passedStuff[2]

	currentTurn = passedStuff[3]

	for x in range(0,len(casteNamesAndApprovals)):
		#no -1 because max is exclusive
		var item = casteNamesAndApprovals[x]
		$ItemList.add_item(item[0]+" "+str(item[1]))	#name  approval







func HideMyStuff():
	$Panel.hide()
	$ItemList.hide()
	$MilitaryMessage.hide()
	$PoliceMessage.hide()
	$MilitaryButton.hide()
	$PoliceButton.hide()
	$CasteButton.hide()
	$InfoLabel.hide()
	$DoneButton.hide()
	$WarningLabel.hide()

func ShowMyStuff():
	$Panel.show()
	$ItemList.show()
	$MilitaryMessage.show()
	$PoliceMessage.show()
	$MilitaryButton.show()
	$PoliceButton.show()
	$CasteButton.show()
	$InfoLabel.show()
	$DoneButton.show()
	$WarningLabel.show()


func _on_DoneButton_pressed():
	emit_signal("UserDoneWithBoostMenu")


func _on_CasteButton_pressed():
	var selectedItems = $ItemList.get_selected_items()

	if len(selectedItems) == 0:
		pass
	elif turnOfLastCasteBoost < 0 or turnOfLastCasteBoost > (currentTurn+5):
		#the +5 is because the boost should last 5 turns, so either you haven't boosted it yet
		#or it's been 5 turns since the last boost
		turnOfLastCasteBoost = currentTurn
		var nameOfCasteToBoost = casteNamesAndApprovals[selectedItems[0]]	#there is only one item in selected items
		nameOfCasteToBoost = nameOfCasteToBoost[0]	#name is the first one in the names and approvals list
		emit_signal("BoostCaste", nameOfCasteToBoost)



func _on_PoliceButton_pressed():
	if turnOfLastPolBoost < 0 or turnOfLastPolBoost > (currentTurn+5):
		turnOfLastPolBoost = currentTurn
		emit_signal("BoostPolice")
	else:
		$WarningLabel.text = "Too soon since last police boost"


func _on_MilitaryButton_pressed():
	if turnOfLastMilBoost < 0 or turnOfLastMilBoost > (currentTurn+5):
		turnOfLastMilBoost = currentTurn
		emit_signal("BoostMilitary")
	else:
		$WarningLabel.text = "Too soon since last military boost"
