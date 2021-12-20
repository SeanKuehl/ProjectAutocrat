
var randomEventName = ""
var randomEventDescription = ""
var randomEventsValues = [0,0,0,0]	#treasury adjustment, random caste adjustment, mil point change(temp), pol point change(temp)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#rawSelection is a list of strings where the first item is the name and the rest are the values
func init(passedName, passedDesc, passedValues):


	randomEventName = passedName

	randomEventDescription = passedDesc

	randomEventsValues = passedValues

func copy(passedName, passedDesc, passedValues):
	randomEventName = passedName

	randomEventDescription = passedDesc

	randomEventsValues = passedValues

func GetName():
	return randomEventName

func GetDescription():
	return randomEventDescription

func GetValues():
	return randomEventsValues



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
