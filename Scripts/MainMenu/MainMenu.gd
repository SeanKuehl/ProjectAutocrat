extends CanvasLayer

onready var caste = load("res://Scenes/Castes/Caste.tscn")

onready var casteEditMenu = load("res://Scenes/Castes/CasteEditMenu.tscn")

signal UserWantsToCreateCaste()

var casteName = ""
var casteDesc = ""

var selectionsList = []
var rightsList = []
var occupationList = []

var casteList = []

func _ready():
	casteEditMenu = casteEditMenu.instance()
	get_parent().ConnectCasteEditMenuSignals(casteEditMenu)

	add_child(casteEditMenu)
	get_node("CasteEditMenu").HideMyStuff()

func Init(econPoints, polPoints, milPoints):
	$EconomyPointsLabel.text = "Economy Points: "+str(econPoints)
	$PolicePointsLabel.text = "Police Points: "+str(polPoints)
	$MilitaryPointsLabel.text = "Military Points: "+str(milPoints)

func AddNewlyCreatedCaste(newCasteInfo):
	var newCaste = caste.instance()
	newCaste.Init(newCasteInfo)
	newCaste.CalculateRightsApproval()
	newCaste.rect_global_position = Vector2(100,100)
	newCaste.connect("UserWantsToEditCaste", self, "DoEditCasteMenu")
	var numOfPeopleInCaste = CalculatePeopleInCasteBeforeConflicts(newCaste.GetSelections())
	newCaste.SetAmountOfPeopleInCaste(numOfPeopleInCaste)
	casteList.append(newCaste)
	add_child(newCaste)


func CalculatePeopleInCasteBeforeConflicts(listOfSelections):
	var populationSizeToAlter = Global.GetPopulationSize()

	for selection in listOfSelections:
		var numberOfSlices = len(selection.GetValues())	#this is how many ways the population is divided, in the case of genders: male, female there are 2 slices, so the population is half men and half women
		var populationPerSlice = populationSizeToAlter / numberOfSlices	#this is integer division, in the case of male, female with a pop of 1000, this number would be 500

		var numberOfSlicesSelected = 0
		var selectedSlices = selection.GetChosenValues()

		for x in selectedSlices:
			if x == true:
				numberOfSlicesSelected += 1

		if numberOfSlicesSelected == numberOfSlices:
			#all are allowed, no need to subtract any from the population
			pass
		else:
			#take the total slices - selected slices to get how many slices are excluded the caste
				#then multiply this by the population per slice, and subtract this from the total population to get how many people
				#are allowed in the caste
			var slicesExcluded = numberOfSlices - numberOfSlicesSelected
			var numberOfPeopleExcluded = slicesExcluded * populationPerSlice
			populationSizeToAlter -= numberOfPeopleExcluded

	return populationSizeToAlter

func ResolveAmountOfPeopleInCasteConflicts():


	for i in range(0,len(casteList)):
		for k in range(i+1, len(casteList)):
			ResolveIndividualConflict(casteList[i], casteList[k])

func ResolveIndividualConflict(casteOne, casteTwo):
	#get their selection lists
	var firstSelectionList = casteOne.GetSelections()
	var secondSelectionList = casteTwo.GetSelections()

	var conflict = true

	#for each selection in both caste selection lists:
	for x in range(0,len(firstSelectionList)):
		#both lists should be the same size

		#get chosen list
		var firstChosenList = firstSelectionList[x].GetChosenValues()
		var secondChosenList = secondSelectionList[x].GetChosenValues()

		for i in range(0, len(firstChosenList)):
			#both chosen lists should be the same size
			if firstChosenList[i] == true and secondChosenList[i] == true:
				conflict = true


		if x == (len(firstSelectionList)-1):
			#it was the last spot, it's really a conflict and must resolved

			if casteOne.GetAmountOfPeopleInCaste() > casteTwo.GetAmountOfPeopleInCaste():
				var numberOfConflictingSlices = 0
				var firstPopulation = casteTwo.GetAmountOfPeopleInCaste()	#first as in this algorithm, not the firstCaste necessarily
				var numberOfSlices = len(secondChosenList)
				var firstNumOfAllowedSlices = 0

				for k in range(0, len(secondChosenList)):
					if secondChosenList[k] == true and secondChosenList[k] == firstChosenList[k]:
						numberOfConflictingSlices += 1

					if secondChosenList[k] == true:
						firstNumOfAllowedSlices += 1

				var popPerSlice = firstPopulation / firstNumOfAllowedSlices
				var popToSubtract = popPerSlice * numberOfConflictingSlices

				#set casteOne's new pop, it's old one - popToSubtract. Make sure to update it in casteList! Maybe have another function do that!
				SetChangeInPopAfterConflict(casteOne.GetID(), popToSubtract)
			#next if the other one has more, then go to rights approval, then throw exception cause it's a tie!

			elif casteTwo.GetAmountOfPeopleInCaste() > casteOne.GetAmountOfPeopleInCaste():
				var numberOfConflictingSlices = 0
				var firstPopulation = casteOne.GetAmountOfPeopleInCaste()	#first as in this algorithm, not the firstCaste necessarily
				var numberOfSlices = len(firstChosenList)
				var firstNumOfAllowedSlices = 0

				for k in range(0, len(secondChosenList)):
					if secondChosenList[k] == true and secondChosenList[k] == firstChosenList[k]:
						numberOfConflictingSlices += 1

					if secondChosenList[k] == true:
						firstNumOfAllowedSlices += 1

				var popPerSlice = firstPopulation / firstNumOfAllowedSlices
				var popToSubtract = popPerSlice * numberOfConflictingSlices

				#set casteOne's new pop, it's old one - popToSubtract. Make sure to update it in casteList! Maybe have another function do that!
				SetChangeInPopAfterConflict(casteTwo.GetID(), popToSubtract)

			elif casteOne.GetRightsApproval() > casteTwo.GetRightsApproval():
				var numberOfConflictingSlices = 0
				var firstPopulation = casteTwo.GetAmountOfPeopleInCaste()	#first as in this algorithm, not the firstCaste necessarily
				var numberOfSlices = len(secondChosenList)
				var firstNumOfAllowedSlices = 0

				for k in range(0, len(secondChosenList)):
					if secondChosenList[k] == true and secondChosenList[k] == firstChosenList[k]:
						numberOfConflictingSlices += 1

					if secondChosenList[k] == true:
						firstNumOfAllowedSlices += 1

				var popPerSlice = firstPopulation / firstNumOfAllowedSlices
				var popToSubtract = popPerSlice * numberOfConflictingSlices

				#set casteOne's new pop, it's old one - popToSubtract. Make sure to update it in casteList! Maybe have another function do that!
				SetChangeInPopAfterConflict(casteOne.GetID(), popToSubtract)

			elif casteTwo.GetRightsApproval() > casteOne.GetRightsApproval():
				var numberOfConflictingSlices = 0
				var firstPopulation = casteOne.GetAmountOfPeopleInCaste()	#first as in this algorithm, not the firstCaste necessarily
				var numberOfSlices = len(firstChosenList)
				var firstNumOfAllowedSlices = 0

				for k in range(0, len(secondChosenList)):
					if secondChosenList[k] == true and secondChosenList[k] == firstChosenList[k]:
						numberOfConflictingSlices += 1

					if secondChosenList[k] == true:
						firstNumOfAllowedSlices += 1

				var popPerSlice = firstPopulation / firstNumOfAllowedSlices
				var popToSubtract = popPerSlice * numberOfConflictingSlices

				#set casteOne's new pop, it's old one - popToSubtract. Make sure to update it in casteList! Maybe have another function do that!
				SetChangeInPopAfterConflict(casteTwo.GetID(), popToSubtract)

			#otherwise it's a tie, this should never happen so for now just throw exception
			else:
				assert(1 != 0, "Two castes have the same pop size and rights approval. What? How?")

		else:
			#it's not a conflict, don't need to change anything
			pass

#call this function when a new caste is added or an old one is changed
func ResetCastesAfterChange():
	for x in range(0,len(casteList)):
		var peopleInCaste = CalculatePeopleInCasteBeforeConflicts(casteList[x].GetSelections())
		casteList[x].SetAmountOfPeopleInCaste(peopleInCaste)

	ResolveAmountOfPeopleInCasteConflicts()

	CalculateCasteRelativeApproval()

	#need get military etc. points and approval

func GetOccupationPopPointsAndApproval():
	#at end determine number in "economy" role by subtracting other role pops from
	#population size
	var militaryPopList = []
	var militaryApprovalList = []

	var policePopList = []
	var policeApprovalList = []

	var overallPointsList = [0,0,0]

	for caste in casteList:
		# getocpoppointsandapproval returns [populationInOccupation, approval, points] where points is a list in itself
		var values = caste.GetOccupationPopPointsAndApproval("Military")
		militaryPopList.append(values[0])
		militaryApprovalList.append(values[1])
		var pointsList = values[2]
		overallPointsList[0] += pointsList[0]
		overallPointsList[1] += pointsList[1]
		overallPointsList[2] += pointsList[2]

		values = caste.GetOccupationPopPointsAndApproval("Police")
		policePopList.append(values[0])
		policeApprovalList.append(values[1])
		pointsList = values[2]
		overallPointsList[0] += pointsList[0]
		overallPointsList[1] += pointsList[1]
		overallPointsList[2] += pointsList[2]


	#find wieghted approvals(weighted to population)
	#polAveragedApproval = polWeightedApprovalSum / polTotalPop;
	var totalPop = 0
	var wieghtedApproval = 0

	var milAverageApproval = 0
	var polAverageApproval = 0
	#will need total pop for each occupation! At least for end for figuring out
	#how many in economy role etc.
	for x in range(0, len(militaryPopList)):
		#the pop and approval lists should be the same length
		#unlike the mil and pol lists of things
		totalPop += militaryPopList[x]
		wieghtedApproval += militaryPopList[x] * militaryApprovalList[x]	#do population times approval
	milAverageApproval = wieghtedApproval / totalPop

	totalPop = 0
	wieghtedApproval = 0

	for x in range(0, len(policePopList)):
		totalPop += policePopList[x]
		wieghtedApproval += policePopList[x] * policeApprovalList[x]
	polAverageApproval = wieghtedApproval / totalPop


func CalculateCasteRelativeApproval():
	for i in range(0,len(casteList)):
		for k in range(0,len(casteList)):
			#don't compare the caste to itself
			if i == k:
				pass
			else:
				#call relative approval function
				SetRelativeApprovalBetweenTwoCastes(casteList[i], casteList[k])


func SetRelativeApprovalBetweenTwoCastes(casteOne, casteTwo):
	var firstPop = casteOne.GetAmountOfPeopleInCaste()
	var secondPop = casteTwo.GetAmountOfPeopleInCaste()

	var firstRightsApproval = casteOne.GetRightsApproval()
	var secondRightsApproval = casteTwo.GetRightsApproval()

	var rightsPoints = 0
	var popPoints = (abs(firstPop - secondPop)) / 100

	if firstRightsApproval > secondRightsApproval:
		rightsPoints = (abs(firstRightsApproval - secondRightsApproval)) / 10

			#this is the relative approval from only this other caste, there could be more so it's added to the current points, not set
		var newRelativeApproval = casteOne.GetRelativeApproval() + (rightsPoints * popPoints)

			#only first needs to be set because the other caste will have it's time when it's the one being compared

		SetCasteRelativeApproval(casteOne.GetID(), newRelativeApproval)

	elif secondRightsApproval > firstRightsApproval:
		rightsPoints = (abs(secondRightsApproval - firstRightsApproval)) / 10

			#this is the relative approval from only this other caste, there could be more so it's added to the current points, not set
		var newRelativeApproval = casteOne.GetRelativeApproval() + (rightsPoints * popPoints)

			#only first needs to be set because the other caste will have it's time when it's the one being compared
			#if second is treated better, then relative approval is negative

		SetCasteRelativeApproval(casteOne.GetID(), newRelativeApproval*-1)

	else:
		#they are the same and there's no relative approval to be gained or lost
		pass


func SetCasteRelativeApproval(casteID, newRelativeApproval):
	for x in range(0,len(casteList)):
		if casteList[x].GetID() == casteID:

			casteList[x].SetRelativeApproval(newRelativeApproval)


func SetChangeInPopAfterConflict(casteID, popToSubtract):
	for x in range(0,len(casteList)):
		if casteList[x].GetID() == casteID:
			var newAmountOfPeople = casteList[x].GetAmountOfPeopleInCaste() - popToSubtract
			casteList[x].SetAmountOfPeopleInCaste(newAmountOfPeople)



func ConnectSignalsFromRoot(root):
	root.connect("EditCasteNameAndDesc", self, "UpdateCasteNameAndDesc")
	root.connect("EditCasteSelections", self, "UpdateCasteSelections")


func HideMyStuff():
	$Panel.hide()
	$EconomyPointsLabel.hide()
	$PolicePointsLabel.hide()
	$MilitaryPointsLabel.hide()
	$CreateCasteButton.hide()

	#hide the castes
	for x in range(0,len(casteList)):
		casteList[x].HideMyStuff()

func ShowMyStuff():
	$Panel.show()
	$EconomyPointsLabel.show()
	$PolicePointsLabel.show()
	$MilitaryPointsLabel.show()
	$CreateCasteButton.show()

	#show the castes
	for x in range(0,len(casteList)):
		casteList[x].ShowMyStuff()

func UpdateCasteSelections(selections, passedCasteID):
	for x in range(0, len(casteList)):
		#don't need -1 because max is exclusive
		if casteList[x].GetID() == passedCasteID:
			casteList[x].SetSelections(selections)

func UpdateCasteNameAndDesc(passedCasteName, passedCasteDesc, passedCasteID):

	for x in range(0,len(casteList)):
		#don't need -1 because max is exclusive
		if casteList[x].GetID() == passedCasteID:
			casteList[x].SetNameAndDesc(passedCasteName, passedCasteDesc)

func DoEditCasteMenu(casteInfo, casteID):
	HideMyStuff()
	get_node("CasteEditMenu").ShowMyStuff()
	get_node("CasteEditMenu").Init(casteInfo)

func _on_CreateCasteButton_pressed():
	emit_signal("UserWantsToCreateCaste")
