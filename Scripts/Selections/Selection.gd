
var selectionName = ""
var valuesList = []
var chosenValuesList = []	#booleans corresponding to a value in the values list to indicate whether or not it's been chosen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#rawSelection is a list of strings where the first item is the name and the rest are the values
func init(rawSelection):
	var nameIndex = 0

	selectionName = rawSelection[nameIndex]

	for x in range(nameIndex+1,len(rawSelection)):
		#max is exclusive
		valuesList.append(rawSelection[x])

	#now load chosen values list
	for x in valuesList:
		chosenValuesList.append(false)	#these will be changes to true if chosen by the user


func copy(passedName, passedValuesList, passedChosenValues):
	selectionName = passedName
	valuesList = passedValuesList
	chosenValuesList = passedChosenValues

func GetName():
	return selectionName

func GetValues():
	return valuesList

func GetChosenValues():
	return chosenValuesList



func SetChosenValues(newValues):

	#if all are false, that's impossible and should be corrected to all true
	var allAreFalse = true
	for x in newValues:
		if x == true:
			allAreFalse = false
			break

	if allAreFalse:
		for x in range(0, len(newValues)):
			#len and not len-1 because max is exclusive
			newValues[x] = true


	chosenValuesList = newValues

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
