extends CanvasLayer

signal UserWantsToEditNameAndDescription(casteName, casteDesc, casteID)
signal UserWantsToEditSelections(selections, casteID)


var casteName = ""
var casteDesc = ""

var selectionsList = []
var rightsList = []
var occupationList = []

var ID = -1

func _ready():
	pass


func Init(newCasteInfo):
	casteName = newCasteInfo[0]
	casteDesc = newCasteInfo[1]
	selectionsList = newCasteInfo[2]
	rightsList = newCasteInfo[3]
	occupationList = newCasteInfo[4]
	ID = newCasteInfo[5]

	$CasteNameLabel.text = casteName
	$DescContainer/Desc.text = casteDesc


func HideMyStuff():
	$Panel.hide()
	$NamePrompt.hide()
	$CasteNameLabel.hide()
	$CasteNameEditButton.hide()
	$DescriptionPrompt.hide()

	$DescContainer.hide()
	$DescContainer/Desc.hide()

	$CasteDescEditButton.hide()
	$CasteSelectionsPrompt.hide()
	$CasteRightsPrompt.hide()
	$CasteOccupationsPrompt.hide()
	$SelectionsEditButton.hide()
	$RightsEditButton.hide()
	$OccupationsEditButton.hide()
	$DoneButton.hide()
	$DeleteCasteButton.hide()

func ShowMyStuff():
	$Panel.show()
	$NamePrompt.show()
	$CasteNameLabel.show()
	$CasteNameEditButton.show()
	$DescriptionPrompt.show()

	$DescContainer.show()
	$DescContainer/Desc.show()

	$CasteDescEditButton.show()
	$CasteSelectionsPrompt.show()
	$CasteRightsPrompt.show()
	$CasteOccupationsPrompt.show()
	$SelectionsEditButton.show()
	$RightsEditButton.show()
	$OccupationsEditButton.show()
	$DoneButton.show()
	$DeleteCasteButton.show()


func _on_CasteNameEditButton_pressed():
	HideMyStuff()
	emit_signal("UserWantsToEditNameAndDescription", casteName, casteDesc, ID)


func _on_CasteDescEditButton_pressed():
	HideMyStuff()
	emit_signal("UserWantsToEditNameAndDescription", casteName, casteDesc, ID)


func _on_SelectionsEditButton_pressed():
	HideMyStuff()

	emit_signal("UserWantsToEditSelections", selectionsList, ID)
