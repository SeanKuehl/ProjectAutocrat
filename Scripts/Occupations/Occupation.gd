var occupationName = ""
var militaryPointsMultiplier = 0
var policePointsMultiplier = 0
var economyPointsMultiplier = 0
var selected = false	#whether the caste will participate in this role or not

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#rawSelection is a list of strings where the first item is the name and the rest are the values
func init(passedOccupationName, values):
	occupationName = passedOccupationName
	#econ, police, military
	var econIndex = 0
	var polIndex = 1
	var milIndex = 2

	economyPointsMultiplier = values[econIndex]
	policePointsMultiplier = values[polIndex]
	militaryPointsMultiplier = values[milIndex]


func GetName():
	return occupationName

func GetMilitaryMultiplier():
	return militaryPointsMultiplier

func GetPoliceMultiplier():
	return policePointsMultiplier

func GetEconomyMultiplier():
	return economyPointsMultiplier

func GetSelected():
	return selected

func SetSelected(newVal):

	selected = newVal



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
