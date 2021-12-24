var sampleDir = "user://RandomEventsFolder/"
var randomEventScript = load("res://Scripts/RandomEvents/RandomEvent.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init():

	var file = GetFilePathsInDirectory(sampleDir)

	var randomEvents = ReadLinesFromFile(file[0])


	var randomEventNames = []
	var randomEventDesc = []
	var randomEventValues = []

	var listOfRandomEvents = []

	var linesUsed = 0
	#three lines per event

	for x in randomEvents:

		if linesUsed == 0:

			var temp = x
			if len(temp) == 0:
				#it was blank, skip
				pass
			else:

				randomEventNames.append(temp)

			linesUsed += 1

		elif linesUsed == 1:
			var temp = x
			if len(temp) == 0:
				#it was blank, skip
				pass
			else:

				randomEventDesc.append(temp)

			linesUsed += 1

		elif linesUsed == 2:
			var temp = x.split(",")
			if len(temp) == 0:
				#if it was blank, skip
				pass
			else:
				randomEventValues.append(temp)
			linesUsed = 0



	for x in range(0,len(randomEventNames)):
		#all lists should be same length
		var newEvent = randomEventScript.new()
		newEvent.init(randomEventNames[x], randomEventDesc[x], randomEventValues[x])
		listOfRandomEvents.append(newEvent)


	Global.SetListOfRandomEvents(listOfRandomEvents)




func ReadLinesFromFile(fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)

	file.close()


	return content

func GetFilePathsInDirectory(dir):

	var fileNames = list_files_in_directory(dir)
	var filePaths = []
	#to read from the file, it will need the full path to the file
	for x in fileNames:
		filePaths.append(dir+x)

	return filePaths


#path, a file path
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
