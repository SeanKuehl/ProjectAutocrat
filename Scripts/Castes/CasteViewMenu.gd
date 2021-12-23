extends CanvasLayer


signal UserDoneWithViewMenu()

func _ready():
	pass

#not actually all the points factored in from all roles!

func Init(caste):
	var numInCaste = caste.GetAmountOfPeopleInCaste()
	var militaryStats = caste.GetOccupationPopPointsAndApproval("Military")	#in the form [populationInOccupation, approval, points]
	var policeStats = caste.GetOccupationPopPointsAndApproval("Police")
	var peopleInEconomy = numInCaste - (militaryStats[0] + policeStats[0])
	var milPointsList = militaryStats[2]
	var polPointsList = policeStats[2]
	var economyPoints = (peopleInEconomy * 2.0) + milPointsList[0] + polPointsList[0]	#add the econ points from these roles

	#the stats at 2([2]) is a list of the different kinds of points, econ, pol and mil

	var pointsLabelText = "Military points: "+str(milPointsList[2])+", Police points: "+str(polPointsList[1])+", Economy points: "+str(economyPoints)	#2 is index of mil points, 1 is index of police points
	$PointsLabel.text = pointsLabelText

	var totalApproval = caste.GetRightsApproval() + caste.GetRelativeApproval()
	var approvalLabelText = "Rights approval: "+str(caste.GetRightsApproval())+", Relative approval: "+str(caste.GetRelativeApproval())+", Total approval: "+str(totalApproval)
	$ApprovalLabel.text = approvalLabelText

	var peopleInCasteAndRolesText = "People in caste: "+str(numInCaste)+", People in military in caste: "+str(militaryStats[0])+", People in police in caste: "+str(policeStats[0])+", People in economy in caste: "+str(peopleInEconomy)
	$PeopleInCasteAndRolesLabel.text = peopleInCasteAndRolesText


func HideMyStuff():
	$Panel.hide()
	$PointsLabel.hide()
	$ApprovalLabel.hide()
	$PeopleInCasteAndRolesLabel.hide()
	$DoneButton.hide()

func ShowMyStuff():
	$Panel.show()
	$PointsLabel.show()
	$ApprovalLabel.show()
	$PeopleInCasteAndRolesLabel.show()
	$DoneButton.show()


func _on_DoneButton_pressed():
	emit_signal("UserDoneWithViewMenu")
