extends Control

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


func _ready():
	pass

func CalculateRightsApproval():
	var total = 0

	for x in range(0,len(rightsList)):
		var doubleValues = rightsList[x].GetDoubleValues()
		var indexOfValueToAdd = rightsList[x].GetChosenIndex()
		total += doubleValues[indexOfValueToAdd]

	rightsApproval = total

func GetRightsApproval():
	return rightsApproval

func GetRelativeApproval():
	return relativeApproval

func SetRelativeApproval(newValue):
	relativeApproval = newValue

func GetID():
	return ID

func SetAmountOfPeopleInCaste(newValue):
	amountOfPeopleInCaste = newValue

func GetAmountOfPeopleInCaste():
	return amountOfPeopleInCaste

func HideMyStuff():
	$Panel.hide()
	$NameLabel.hide()
	$EditButton.hide()

	mouse_filter = Control.MOUSE_FILTER_IGNORE

func ShowMyStuff():
	$Panel.show()
	$NameLabel.show()
	$EditButton.show()

	mouse_filter = Control.MOUSE_FILTER_STOP	#since it's a control node, unless these two are done then
	#it will keep picking up input events even if hidden and behind other menus

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
			multipliersList = [x.GetEconomyMultiplier(), x.GetPoliceMultiplier(), x.GetMilitaryMultiplier()]

	if occupationIsEnabled:
		populationInOccupation = GetAmountOfPeopleInCaste() / waysToDividePopBy
		points = [multipliersList[0]*populationInOccupation, multipliersList[1]*populationInOccupation, multipliersList[2]*populationInOccupation]

	return [populationInOccupation, approval, points]

func SetNameAndDesc(passedName, passedDesc):
	casteName = passedName
	casteDesc = passedDesc

	$NameLabel.text = casteName

func SetSelections(passedSelections):
	selectionsList = passedSelections

func GetSelections():
	return selectionsList

func Init(newCasteInfo):

	casteName = newCasteInfo[0]
	casteDesc = newCasteInfo[1]
	selectionsList = newCasteInfo[2]
	rightsList = newCasteInfo[3]
	occupationList = newCasteInfo[4]

	infoList = newCasteInfo

	ID = Global.GetNewCasteID()
	infoList.append(ID)
	$NameLabel.text = casteName

func _on_EditButton_pressed():
	#caste info could have been edited since last time, remake infoList
	infoList = [casteName, casteDesc, selectionsList, rightsList, occupationList, ID]

	emit_signal("UserWantsToEditCaste", infoList, ID)

