extends Control

var selectionClass = load("res://Scripts/Selections/Selection.gd")


var casteName = ""
var casteDesc = ""

var selectionsList = []
var rightsList = []
var occupationList = []
var amountOfPeopleInCaste = -1

var rightsApproval = -1
var relativeApproval = 0

var infoList = []

var ID = -1

signal UserWantsToEditCaste(casteInfo, casteID)
signal UserWantsToViewCaste(casteID)

func _ready():
	pass

func GetName():
	return casteName

func CalculateRightsApproval():
	var total = 0

	for x in range(0,len(rightsList)):
		var doubleValues = rightsList[x].GetDoubleValues()
		var indexOfValueToAdd = rightsList[x].GetChosenIndex()
		total += float(doubleValues[indexOfValueToAdd])

	rightsApproval = total

func GetRightsApproval():
	return rightsApproval

func SetRightsApproval(newVal):
	rightsApproval = newVal

func GetRelativeApproval():
	return relativeApproval

func SetRelativeApproval(newValue):
	relativeApproval = newValue

func GetTotalApproval():
	return (rightsApproval+relativeApproval)

func GetID():
	return ID

func SetAmountOfPeopleInCaste(newValue):
	amountOfPeopleInCaste = newValue

func GetAmountOfPeopleInCaste():
	return amountOfPeopleInCaste

func CalculateCostOfRights():
	#(people in caste / 100) * sum of positive rights = cost of rights
	#it costs money to give out posititve rights
	var totalCostOfRights = 0

	for x in range(0,len(rightsList)):
		var doubleValues = rightsList[x].GetDoubleValues()
		var indexOfValueToAdd = rightsList[x].GetChosenIndex()

		#if it's a posititve right, add it
		if float(doubleValues[indexOfValueToAdd]) > 0:

			totalCostOfRights += float(doubleValues[indexOfValueToAdd])

	totalCostOfRights = (GetAmountOfPeopleInCaste()/100) * totalCostOfRights
	return totalCostOfRights

func HideMyStuff():
	$Panel.hide()
	$NameLabel.hide()
	$EditButton.hide()
	$ViewButton.hide()

	mouse_filter = Control.MOUSE_FILTER_IGNORE


func ShowMyStuff():
	$Panel.show()
	$NameLabel.show()
	$EditButton.show()
	$ViewButton.show()

	mouse_filter = Control.MOUSE_FILTER_STOP


#occupationName is a string with the name
func GetOccupationPopPointsAndApproval(occupationName):
	#get population, points and approval
	#population is how much of the caste's population is employed in it
	#points is that population times each of the three multipliers(3 different vals)
	#approval is the approval of the caste

	var waysToDividePopBy = 1	#start at 1 because economy is an occupation but not listed on file
	var multipliersList = []
	var points = [0,0,0]
	var approval = GetRightsApproval() + GetRelativeApproval()
	var populationInOccupation = 0
	var occupationIsEnabled = false


	for x in occupationList:
		if x.GetSelected() == true:
			waysToDividePopBy += 1
		if x.GetName() == occupationName and x.GetSelected() == true:
			occupationIsEnabled = true
			multipliersList = [float(x.GetEconomyMultiplier()), float(x.GetPoliceMultiplier()), float(x.GetMilitaryMultiplier())]

	if occupationIsEnabled:
		populationInOccupation = GetAmountOfPeopleInCaste() / waysToDividePopBy
		points = [multipliersList[0]*populationInOccupation, multipliersList[1]*populationInOccupation, multipliersList[2]*populationInOccupation]

	return [populationInOccupation, approval, points]

func SetNameAndDesc(passedName, passedDesc):
	casteName = passedName
	casteDesc = passedDesc

	$NameLabel.text = casteName

func SetSelections(passedSelections):

	selectionsList = DerefSelectionsList(passedSelections)
	#selectionsList = passedSelections

func GetSelections():
	return DerefSelectionsList(selectionsList)

func SetRights(passedRights):
	rightsList = passedRights


func SetOccupations(passedOccupations):
	occupationList = passedOccupations


func Init(newCasteInfo):



	casteName = newCasteInfo[0]
	casteDesc = newCasteInfo[1]
	selectionsList = DerefSelectionsList(newCasteInfo[2])
	rightsList = newCasteInfo[3]
	occupationList = newCasteInfo[4]

	infoList = newCasteInfo

	ID = Global.GetNewCasteID()
	infoList.append(ID)
	$NameLabel.text = casteName


func DerefSelectionsList(listOfSelections):
	var derefToSend = []
	#make a new instance of the object, duplicating all the fields!
	for x in range(0,len(listOfSelections)):
		var newName = listOfSelections[x].GetName()
		var newValues = listOfSelections[x].GetValues()
		var newChosen = listOfSelections[x].GetChosenValues()
		var newSelection = selectionClass.new()
		newSelection.copy(newName, newValues, newChosen)
		derefToSend.append(newSelection)

	return derefToSend



func _on_EditButton_pressed():
	#caste info could have been edited since last time, remake infoList
	infoList = [casteName, casteDesc, selectionsList, rightsList, occupationList, ID]

	emit_signal("UserWantsToEditCaste", infoList, ID)



func _on_ViewButton_pressed():
	#only ID because we need some values like rights approval that we don't have in infoList
	emit_signal("UserWantsToViewCaste", ID)
