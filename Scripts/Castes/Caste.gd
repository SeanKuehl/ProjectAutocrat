extends Control

var casteName = ""
var casteDesc = ""

var selectionsList = []
var rightsList = []
var occupationList = []

var infoList = []

var ID = -1

signal UserWantsToEditCaste(casteInfo, casteID)


func _ready():
	pass

func GetID():
	return ID

func HideMyStuff():
	$Panel.hide()
	$NameLabel.hide()
	$EditButton.hide()

	mouse_filter = Control.MOUSE_FILTER_IGNORE

func ShowMyStuff():
	$Panel.show()
	$NameLabel.show()
	$EditButton.show()

	mouse_filter = Control.MOUSE_FILTER_STOP

func SetNameAndDesc(passedName, passedDesc):
	casteName = passedName
	casteDesc = passedDesc

	$NameLabel.text = casteName

func SetSelections(passedSelections):
	selectionsList = passedSelections

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

