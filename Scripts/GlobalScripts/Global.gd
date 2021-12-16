extends Node

var listOfSelections = []	#other things will copy from here and make changes to their local copy
var listOfRights = []
var listOfOccupations = []

func SetListOfSelections(newValue):
	listOfSelections = newValue

func GetListOfSelections():
	return listOfSelections

func SetListOfRights(newValue):
	listOfRights = newValue

func GetListOfRights():
	return listOfRights

func GetListOfOccupations():
	return listOfOccupations

func SetListOfOccupations(newVal):
	listOfOccupations = newVal

func _ready():
	pass
