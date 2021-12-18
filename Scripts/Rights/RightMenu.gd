extends CanvasLayer

onready var rightList = 0	#create a local copy of the global list to make changes to
var rightIndex = 0
var mode = "Create"



signal UserDoneWithRightChanges(rightList)


func HideMyStuff():
	$Panel.hide()
	$ItemList.hide()
	$IntroLabel.hide()
	$HowManyLeftLabel.hide()
	$NextButton.hide()
	$BackButton.hide()

func ShowMyStuff():
	$Panel.show()
	$ItemList.show()
	$IntroLabel.show()
	$HowManyLeftLabel.show()
	$NextButton.show()
	$BackButton.show()


func CreateRightList():
	rightIndex = 0
	rightList = Global.GetListOfRights()	#create a local copy of the global list to make changes to

	UpdateDisplay()

func EditRightList(rightsListToEdit):
	mode = "Edit"
	rightIndex = 0
	rightList = rightsListToEdit
	EditUpdateDisplay()

func EditUpdateDisplay():

	$ItemList.clear()

	var newStringValueList = rightList[rightIndex].GetStringValues()
	var newDoubleValueList = rightList[rightIndex].GetDoubleValues()
	var selectedIndex = rightList[rightIndex].GetChosenIndex()

	for x in range(0,len(newStringValueList)):
		#no -1 because max is exclusive
		$ItemList.add_item(newStringValueList[x]+", approval effect: "+str(newDoubleValueList[x]))	#thisis the part I'll change

	$ItemList.select(selectedIndex, false)
	emit_signal("item_selected", selectedIndex)







	$IntroLabel.text = "How do you want "+rightList[rightIndex].GetName()+" to effect this caste?"
	$HowManyLeftLabel.text = str((rightIndex+1))+"/"+str((len(rightList)))




func UpdateDisplay():
	$ItemList.clear()

	var newStringValueList = rightList[rightIndex].GetStringValues()
	var newDoubleValueList = rightList[rightIndex].GetDoubleValues()
	var selectedIndex = rightList[rightIndex].GetChosenIndex()

	for x in range(0,len(newStringValueList)):
		#no -1 because max is exclusive
		$ItemList.add_item(newStringValueList[x]+", approval effect: "+str(newDoubleValueList[x]))	#thisis the part I'll change

	$ItemList.select(selectedIndex, false)
	emit_signal("item_selected", selectedIndex)

	$IntroLabel.text = "How do you want "+rightList[rightIndex].GetName()+" to effect this caste?"
	$HowManyLeftLabel.text = str((rightIndex+1))+"/"+str((len(rightList)))


func _on_NextButton_pressed():
	#if no more selections, finish


	#save the data they've selected to the local copy of the selections list
	var newSelectedItems = $ItemList.get_selected_items()

	if len(newSelectedItems) == 0:
		#default to the first value
		newSelectedItems = [0]


	#only one item should be selected
	rightList[rightIndex].SetChosenIndex(newSelectedItems[0])


	if rightIndex == (len(rightList)-1):
		#if there are no more selections, finish
		HideMyStuff()
		emit_signal("UserDoneWithRightChanges", rightList)

	else:
		#keep going

		if mode == "Create":

			rightIndex += 1
			UpdateDisplay()
		else:
			rightIndex += 1
			EditUpdateDisplay()




func _on_BackButton_pressed():
	#if no previouse selections, don't go back
	#don't need to save current user selections made, overwrite them
	if rightIndex == 0:
		#there are no more to go back to
		pass
	else:



		if mode == "Create":

			rightIndex -= 1
			UpdateDisplay()
		else:
			rightIndex -= 1
			EditUpdateDisplay()
