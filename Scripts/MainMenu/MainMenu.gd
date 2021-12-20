extends CanvasLayer

onready var caste = load("res://Scenes/Castes/Caste.tscn")

onready var casteEditMenu = load("res://Scenes/Castes/CasteEditMenu.tscn")

onready var randomEventMenu = load("res://Scenes/RandomEvents/RandomEventMenu.tscn")

signal UserWantsToCreateCaste()

var casteName = ""
var casteDesc = ""

var selectionsList = []
var rightsList = []
var occupationList = []

var casteList = []

var milPopAndApprovalList = [0,0]	#pop, approval
var polPopAndApprovalList = [0,0]	#pop, approval
var occupationPoints = [0,0,0]	#econ, pol, mil

var treasury = 500	#this is the initial amount in the treasury
var turn = 1

var numberOfCastesInRow = 1
var startingX = 100
var startingY = 200

var casteTemporaryApprovalChanges = []
var temporaryMilPointChanges = []
var temporaryPolPointChanges = []

func _ready():
	var turnLabelText = "Turn: "+str(turn)
	$TurnLabel.text = turnLabelText

	var treasuryLabelText = "Treasury: "+str(treasury)
	$TreasuryLabel.text = treasuryLabelText


	casteEditMenu = casteEditMenu.instance()
	casteEditMenu.connect("UserIsDoneWithCasteEditMenu", self, "HideCasteEditMenu")

	casteEditMenu.connect("UserWantsToDeleteCaste", self, "DeleteCasteAndCloseEditMenu")
	get_parent().ConnectCasteEditMenuSignals(casteEditMenu)
	add_child(casteEditMenu)
	get_node("CasteEditMenu").HideMyStuff()

	randomEventMenu = randomEventMenu.instance()
	randomEventMenu.connect("UserDoneWithRandomEventMenu", self, "HideRandomEventMenu")
	add_child(randomEventMenu)
	get_node("RandomEventMenu").HideMyStuff()


func DeleteCasteAndCloseEditMenu(casteID):
	#hide casteEditMenu
	get_node("CasteEditMenu").HideMyStuff()

	#remove the caste
	var casteToRemove = 0
	for x in range(0,len(casteList)):
		if casteList[x].GetID() == casteID:
			casteToRemove = casteList[x]

	casteList.erase(casteToRemove)

	#update all castes after this change
	ResetCastesAfterChange()

func HideCasteEditMenu():
	get_node("CasteEditMenu").HideMyStuff()

func HideRandomEventMenu():
	get_node("RandomEventMenu").HideMyStuff()

func Init(econPoints, polPoints, milPoints):
	$EconomyPointsLabel.text = "Economy Points: "+str(econPoints)
	$PolicePointsLabel.text = "Police Points: "+str(polPoints)
	$MilitaryPointsLabel.text = "Military Points: "+str(milPoints)

func AddNewlyCreatedCaste(newCasteInfo):



	var newCaste = caste.instance()

	newCaste.Init(newCasteInfo)
	newCaste.CalculateRightsApproval()



	if numberOfCastesInRow == 1:
		newCaste.rect_global_position = Vector2(startingX,startingY)
	elif numberOfCastesInRow == 2:
		newCaste.rect_global_position = Vector2(startingX+200,startingY)
	elif numberOfCastesInRow == 3:
		newCaste.rect_global_position = Vector2(startingX+400,startingY)


	numberOfCastesInRow += 1
	if numberOfCastesInRow == 4:
		startingY += 200
		numberOfCastesInRow = 1

	newCaste.connect("UserWantsToEditCaste", self, "DoEditCasteMenu")


	casteList.append(newCaste)
	ResetCastesAfterChange()



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
		print(casteList[x].GetName())
		print(casteList[x].GetRightsApproval())
		print(casteList[x].GetRelativeApproval())
		print(casteList[x].GetAmountOfPeopleInCaste())
		print(casteList[x].GetID())


	ResolveAmountOfPeopleInCasteConflicts()

	CalculateCasteRelativeApproval()

	GetOccupationPopPointsAndApproval()

	$EconomyPointsLabel.text = "Economy Points: "+str(occupationPoints[0])
	$PolicePointsLabel.text = "Police Points: "+str(occupationPoints[1])
	$MilitaryPointsLabel.text = "Military Points: "+str(occupationPoints[2])

	for x in range(0,len(casteList)):
		print(casteList[x].GetName())
		print(casteList[x].GetRightsApproval())
		print(casteList[x].GetRelativeApproval())
		print(casteList[x].GetAmountOfPeopleInCaste())
		print(casteList[x].GetID())


func GetOccupationPopPointsAndApproval():
	#at end determine number in "economy" role by subtracting other role pops from
	#population size
	var militaryPopList = []
	var militaryApprovalList = []

	var policePopList = []
	var policeApprovalList = []

	var overallPointsList = [0,0,0]	#econ, pol, mil

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
	var milTotalPop = 0
	var milWieghtedApproval = 0
	var milAverageApproval = 0

	var polTotalPop = 0
	var polWieghtedApproval = 0
	var polAverageApproval = 0
	#will need total pop for each occupation! At least for end for figuring out
	#how many in economy role etc.
	for x in range(0, len(militaryPopList)):
		#the pop and approval lists should be the same length
		#unlike the mil and pol lists of things
		milTotalPop += militaryPopList[x]
		milWieghtedApproval += militaryPopList[x] * militaryApprovalList[x]	#do population times approval
	if milTotalPop == 0:
		milAverageApproval = 0
	else:
		milAverageApproval = milWieghtedApproval / milTotalPop


	#now get for police
	for x in range(0, len(policePopList)):
		polTotalPop += policePopList[x]
		polWieghtedApproval += policePopList[x] * policeApprovalList[x]

	if polTotalPop == 0:
		polAverageApproval = 0
	else:
		polAverageApproval = polWieghtedApproval / polTotalPop

	#now get for economy role, everyone not in another role
	var popInEcon = Global.GetPopulationSize() - (polTotalPop + milTotalPop)
	#econ has *2 multiplier for econ points
	overallPointsList[0] += 2 * popInEcon


	milPopAndApprovalList[0] = milTotalPop
	milPopAndApprovalList[1] = milAverageApproval

	polPopAndApprovalList[0] = polTotalPop
	polPopAndApprovalList[0] = polAverageApproval

	occupationPoints = overallPointsList


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
	root.connect("EditCasteRights", self, "UpdateCasteRights")
	root.connect("EditCasteOccupations", self, "UpdateCasteOccupations")


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

func UpdateCasteRights(rights, passedCasteID):
	for x in range(0, len(casteList)):
		#don't need -1 because max is exclusive
		if casteList[x].GetID() == passedCasteID:
			casteList[x].SetRights(rights)

func UpdateCasteOccupations(occupations, passedCasteID):
	for x in range(0, len(casteList)):
		#don't need -1 because max is exclusive
		if casteList[x].GetID() == passedCasteID:
			casteList[x].SetOccupations(occupations)

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

func HandleRandomEvent(event):
	#event values in the order:
	#treasury adjustment, random caste adjustment, mil point change(temp), pol point change(temp)
	var values = event.GetValues()

	#adjust the treasury
	treasury += int(values[0])

	#if there is an amount to adjust a random caste by, adjust a random caste
	if int(values[1]) == 0:
		#no change, ignore
		pass
	else:
		#there is a change, pick a random caste and apply the change to it
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var randomCasteIndex = rng.randi_range(0, len(casteList)-1)	#max inclusive
		var randomCasteID = casteList[randomCasteIndex].GetID()

		for x in range(0,len(casteList)):
			if casteList[x].GetID() == randomCasteID:
				#casteTemporaryApprovalChanges
				var old = casteList[x].GetRightsApproval()
				var new = old + int(values[1])
				casteList[x].SetRightsApproval(new)
				casteTemporaryApprovalChanges.append([int(values[1]), turn+5, randomCasteID])	#in 5 turns this will be undone


	#do temp military point change

	milPopAndApprovalList[1] += int(values[2])	#the first one at [1] is approval
	temporaryMilPointChanges.append([turn+5, int(values[2])])	#in 5 turns undo it


	#do temp police point change

	polPopAndApprovalList[1] += int(values[3])

	temporaryPolPointChanges.append([turn+5, int(values[3])])


func HandleRemovingTemporaryChanges():

	#first check if any police point changes are due
	var indexesToRemove = []
	for x in range(0, len(temporaryPolPointChanges)):
		var currentChange = temporaryPolPointChanges[x]
		if currentChange[0] == turn:
			#this change is due to be undone
			polPopAndApprovalList[1] -= currentChange[1]
			indexesToRemove.append([currentChange[0], currentChange[1]])

	for x in indexesToRemove:
		temporaryPolPointChanges.erase(x)


	#next check if any military point changes are due
	indexesToRemove = []
	for x in range(0, len(temporaryMilPointChanges)):
		var currentChange = temporaryMilPointChanges[x]
		if currentChange[0] == turn:
			#it's due to be undone
			milPopAndApprovalList[1] -= currentChange[1]
			indexesToRemove.append([currentChange[0], currentChange[1]])


	for x in indexesToRemove:
		temporaryPolPointChanges.erase(x)


	#handle caste approval changes
	#[int(values[1]), turn+5, randomCasteID]
	indexesToRemove = []
	for x in range(0, len(casteTemporaryApprovalChanges)):
		var currentChange = casteTemporaryApprovalChanges[x]
		if currentChange[1] == turn:
			#it's due to be undone
			UndoCasteTempApprovalChange(currentChange[2], currentChange[0])
			indexesToRemove.append(currentChange)


	for x in indexesToRemove:
		casteTemporaryApprovalChanges.erase(x)




func UndoCasteTempApprovalChange(casteID, value):

	for x in range(0, len(casteList)):
		if casteList[x].GetID() == casteID:
			var old = casteList[x].GetRightsApproval()
			var new = old - value
			casteList[x].SetRightsApproval(new)

func _on_EndTurnButton_pressed():
	turn += 1
	var turnLabelText = "Turn: "+str(turn)
	$TurnLabel.text = turnLabelText

	var randomEvent = Global.GetRandomEventAtRandom()
	if typeof(randomEvent) == TYPE_OBJECT:
		HandleRandomEvent(randomEvent)
		get_node("RandomEventMenu").ShowMyStuff()
		get_node("RandomEventMenu").ShowEvent(randomEvent)
	else:
		pass


	#check if any temp changes need to be undone
	HandleRemovingTemporaryChanges()

	treasury += occupationPoints[0]	#econ points
	var treasuryLabelText = "Treasury: "+str(treasury)
	$TreasuryLabel.text = treasuryLabelText

