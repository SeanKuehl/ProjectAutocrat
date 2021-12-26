extends CanvasLayer

onready var occupationList = 0	#create a local copy of the global list to make changes to
var occupationIndex = 0
var mode = "Create"



signal UserDoneWithOccupationChanges(occupationList)


func HideMyStuff():
	$Panel.hide()
	$ItemList.hide()
	$IntroLabel.hide()
	$HowManyLeftLabel.hide()
	$NextButton.hide()
	$BackButton.hide()
	$NoteLabel.hide()

func ShowMyStuff():
	$Panel.show()
	$ItemList.show()
	$IntroLabel.show()
	$HowManyLeftLabel.show()
	$NextButton.show()
	$BackButton.show()
	$NoteLabel.show()


func CreateOccupationList():
	mode = "Create"
	occupationIndex = 0
	occupationList = Global.GetListOfOccupations()	#create a local copy of the global list to make changes to
	UpdateDisplay()

func EditOccupationList(occupationsListToEdit):
	mode = "Edit"
	occupationIndex = 0
	occupationList = occupationsListToEdit
	EditUpdateDisplay()

func EditUpdateDisplay():

	$ItemList.clear()

	var selected = occupationList[occupationIndex].GetSelected()

	if selected == true:

		$ItemList.add_item("Yes")
		$ItemList.add_item("No")
		$ItemList.select(0, false)
		emit_signal("item_selected", 0)
	else:
		$ItemList.add_item("Yes")
		$ItemList.add_item("No")
		$ItemList.select(1, false)
		emit_signal("item_selected", 1)







	var lineOne = "Do you want this caste to participate in the "+occupationList[occupationIndex].GetName()+"?\n"
	var lineTwo = "They will provide "+str(occupationList[occupationIndex].GetEconomyMultiplier())+" economy boost, \n"
	var lineThree = str(occupationList[occupationIndex].GetMilitaryMultiplier())+" military boost, and \n"
	var lineFour = str(occupationList[occupationIndex].GetPoliceMultiplier())+" police boost."

	$IntroLabel.text = lineOne+lineTwo+lineThree+lineFour
	$HowManyLeftLabel.text = str((occupationIndex+1))+"/"+str((len(occupationList)))




func UpdateDisplay():
	$ItemList.clear()

	$ItemList.add_item("Yes")
	$ItemList.add_item("No")

	var lineOne = "Do you want this caste to participate in the "+occupationList[occupationIndex].GetName()+"?\n"
	var lineTwo = "They will provide "+str(occupationList[occupationIndex].GetEconomyMultiplier())+" economy boost, \n"
	var lineThree = str(occupationList[occupationIndex].GetMilitaryMultiplier())+" military boost, and \n"
	var lineFour = str(occupationList[occupationIndex].GetPoliceMultiplier())+" police boost."

	$IntroLabel.text = lineOne+lineTwo+lineThree+lineFour
	$HowManyLeftLabel.text = str((occupationIndex+1))+"/"+str((len(occupationList)))


func _on_NextButton_pressed():
	#if no more selections, finish


	#save the data they've selected to the local copy of the selections list
	var newSelectedItems = $ItemList.get_selected_items()

	if len(newSelectedItems) == 0:
		#default to the false
		occupationList[occupationIndex].SetSelected(false)
	elif newSelectedItems[0] == 0:
		#0 is the index of yes
		occupationList[occupationIndex].SetSelected(true)
	else:
		occupationList[occupationIndex].SetSelected(false)


	#only one item should be selected






	if occupationIndex == (len(occupationList)-1):
		#if there are no more selections, finish
		HideMyStuff()
		emit_signal("UserDoneWithOccupationChanges", occupationList)

	else:
		#keep going

		if mode == "Create":

			occupationIndex += 1
			UpdateDisplay()
		else:
			occupationIndex += 1
			EditUpdateDisplay()




func _on_BackButton_pressed():
	#if no previouse selections, don't go back
	#don't need to save current user selections made, overwrite them
	if occupationIndex == 0:
		#there are no more to go back to
		pass
	else:



		if mode == "Create":

			occupationIndex -= 1
			UpdateDisplay()
		else:
			occupationIndex -= 1
			EditUpdateDisplay()
