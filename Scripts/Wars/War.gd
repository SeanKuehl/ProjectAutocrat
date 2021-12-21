extends Node

var warCountry = ""
var militaryPoints = 0
var turnsUntilEnd = 0



func _ready():
	pass

func Init(passedName):
	warCountry = passedName
	turnsUntilEnd = 5	#for now just hard code it, will change with balancing later

func GetWarName():
	return warCountry

func GetMilitaryPoints():
	return militaryPoints

func GetTurnsLeft():
	return turnsUntilEnd

func SetTurnsLeft(newVal):
	turnsUntilEnd = newVal

func SetMilitaryPoints(playerMilPoints):

	var minPoints = playerMilPoints - 5
	var maxPoints = playerMilPoints + 5

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var newPoints = rng.randi_range(minPoints, maxPoints)	#max inclusive



	militaryPoints = newPoints
