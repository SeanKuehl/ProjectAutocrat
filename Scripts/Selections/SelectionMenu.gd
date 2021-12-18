extends CanvasLayer

onready var selectionList = 0	#create a local copy of the global list to make changes to
var selectionIndex = 0
var mode = "Create"



signal UserDoneWithSelectionChanges(selectionList)


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


func CreateSelectionList():
	selectionIndex = 0
	selectionList = Global.GetListOfSelections()	#create a local copy of the global list to make changes to

	UpdateDisplay()

func EditSelectionList(selectionsListToEdit):
	mode = "Edit"
	selectionIndex = 0
	selectionList = selectionsListToEdit
	EditUpdateDisplay()

func EditUpdateDisplay():
	$ItemList.clear()

	var newValueList = selectionList[selectionIndex].GetValues()
	var selectedItems = selectionList[selectionIndex].GetChosenValues()


	for x in range(0,len(newValueList)):
		#no -1 because max is exclusive
		$ItemList.add_item(newValueList[x])

		if selectedItems[x] == false:
			$ItemList.unselect(x)
		else:
			$ItemList.select(x, false)
			emit_signal("item_selected", x)		#otherwise it won't be recorded, because select doesn't trigger it






	$IntroLabel.text = "Which "+selectionList[selectionIndex].GetName()+" do you want in this caste?"
	$HowManyLeftLabel.text = str((selectionIndex+1))+"/"+str((len(selectionList)))




func UpdateDisplay():
	$ItemList.clear()

	var newValueList = selectionList[selectionIndex].GetValues()

	for x in newValueList:
		$ItemList.add_item(x)

	$IntroLabel.text = "Which "+selectionList[selectionIndex].GetName()+" do you want in this caste?"
	$HowManyLeftLabel.text = str((selectionIndex+1))+"/"+str((len(selectionList)))


func _on_NextButton_pressed():
	#if no more selections, finish

	#get selection chosen values, change them based on selected, update selection chosen values
	var oldSelectedItems = selectionList[selectionIndex].GetChosenValues()
	#save the data they've selected to the local copy of the selections list
	var newSelectedItems = $ItemList.get_selected_items()

	if mode == "Edit":
		for x in range(0,len(oldSelectedItems)):
			oldSelectedItems[x] = false	#unset them all before setting them again




	for x in newSelectedItems:
		oldSelectedItems[x] = true	#if that index exists in the selections the user made, set it to true that it has been chosen


	selectionList[selectionIndex].SetChosenValues(oldSelectedItems)


	if selectionIndex == (len(selectionList)-1):
		#if there are no more selections, finish
		HideMyStuff()
		emit_signal("UserDoneWithSelectionChanges", selectionList)

	else:
		#keep going

		if mode == "Create":

			selectionIndex += 1
			UpdateDisplay()
		else:
			selectionIndex += 1
			EditUpdateDisplay()




func _on_BackButton_pressed():
	#if no previouse selections, don't go back
	#don't need to save current user selections made, overwrite them
	if selectionIndex == 0:
		#there are no more to go back to
		pass
	else:

		var oldSelectedItems = selectionList[selectionIndex].GetChosenValues()


		for x in range(0,len(oldSelectedItems)):
			oldSelectedItems[x] = false	#overwrite any previouse selections if they were there


		selectionList[selectionIndex].SetChosenValues(oldSelectedItems)

		if mode == "Create":

			selectionIndex -= 1
			UpdateDisplay()
		else:
			selectionIndex -= 1
			EditUpdateDisplay()


