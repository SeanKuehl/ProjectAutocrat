extends Node

var selectionClass = load("res://Scripts/Selections/Selection.gd")
var rightClass = load("res://Scripts/Rights/Right.gd")
var occupationClass = load("res://Scripts/Occupations/Occupation.gd")

var casteIdBase = 0

var listOfSelections = []	#other things will copy from here and make changes to their local copy
var listOfRights = []
var listOfOccupations = []

var listOfRandomEvents = []
var listOfWars = []

var populationSize = 1000


func GetPopulationSize():
	return populationSize

func GetNewCasteID():
	casteIdBase += 1
	return casteIdBase

func SetListOfSelections(newValue):
	listOfSelections = newValue

func GetListOfSelections():


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

func SetListOfRights(newValue):
	listOfRights = newValue

func GetListOfRights():


	var derefToSend = []

	for x in range(0, len(listOfRights)):

		var newName = listOfRights[x].GetName()
		var newStrings = listOfRights[x].GetStringValues()
		var newDoubles = listOfRights[x].GetDoubleValues()
		var newChosenIndex = listOfRights[x].GetChosenIndex()
		var newRight = rightClass.new()
		newRight.copy(newName, newStrings, newDoubles, newChosenIndex)
		derefToSend.append(newRight)


	return derefToSend

func GetListOfOccupations():

	var derefToSend = []

	for x in range(0,len(listOfOccupations)):

		var newName = listOfOccupations[x].GetName()
		var newMilMult = listOfOccupations[x].GetMilitaryMultiplier()
		var newPolMult = listOfOccupations[x].GetPoliceMultiplier()
		var newEconMult = listOfOccupations[x].GetEconomyMultiplier()
		var newSelected = listOfOccupations[x].GetSelected()
		var newOccupation = occupationClass.new()
		newOccupation.copy(newName, newMilMult, newPolMult, newEconMult, newSelected)
		derefToSend.append(newOccupation)

	return derefToSend

func SetListOfOccupations(newVal):
	listOfOccupations = newVal

func SetListOfWars(newVal):
	listOfWars = newVal

func GetRandomWar(playerMilPoints):
	#this will return a random war if
	#a certain random change is met

	#change is one in ten
	var minChance = 1
	var maxChance = 10

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var weatherOrNotToHaveWar = rng.randi_range(minChance, maxChance)	#max inclusive

	if weatherOrNotToHaveWar == 10:
		#get a random war
		var minWarIndex = 0
		var maxWarIndex = len(listOfWars)-1
		var war = listOfWars[rng.randi_range(minWarIndex, maxWarIndex)]
		war.SetMilitaryPoints(playerMilPoints)
		return war
	else:
		return []	#empty list, used to tell that there will be no random event this turn

func SetListOfRandomEvents(newVal):
	listOfRandomEvents = newVal

func GetRandomEventAtRandom():
	#this will return a random random event
	#if a certain random change is met

	var minChance = 1
	var maxChance = 4	#I will check if it's 4, this means there's basically a 1 in 4 chance of a random event

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var weatherOrNotToHaveEvent = rng.randi_range(minChance, maxChance)	#max inclusive

	if weatherOrNotToHaveEvent == 4:
		#get a random random event
		var minEventIndex = 0
		var maxEventIndex = len(listOfRandomEvents)-1
		return listOfRandomEvents[rng.randi_range(minEventIndex, maxEventIndex)]

	else:
		return []	#empty list, used to tell that there will be no random event this turn


func _ready():
	pass
