
var rightName = ""
var stringValuesList = []
var doubleValuesList = []	#booleans corresponding to a value in the values list to indicate whether or not it's been chosen
var chosenIndex = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#rawSelection is a list of strings where the first item is the name and the rest are the values
func init(rawRightStrings, rawRightDoubles):
	var nameIndex = 0

	rightName = rawRightStrings[nameIndex]

	for x in range(nameIndex+1,len(rawRightStrings)):
		#max is exclusive
		stringValuesList.append(rawRightStrings[x])

	for x in range(0, len(rawRightDoubles)):
		doubleValuesList.append(rawRightDoubles[x])


func GetName():
	return rightName

func GetStringValues():
	return stringValuesList

func GetDoubleValues():
	return doubleValuesList

func GetChosenIndex():
	return chosenIndex

func SetChosenIndex(index):
	chosenIndex = index

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
