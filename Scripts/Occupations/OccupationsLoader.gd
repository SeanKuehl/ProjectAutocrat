
var sampleDir = "user://OccupationsFolder/"
var occupationScript = load("res://Scripts/Occupations/Occupation.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init():

	var file = GetFilePathsInDirectory(sampleDir)

	var rights = ReadLinesFromFile(file[0])


	var occupationNameList = []
	var occupationValuesList = []
	var listOfFilteredOccupations = []

	var linesUsed = 0
	var linesPerRight = 2

	for x in rights:

		if linesUsed == 0:

			var temp = x
			if len(temp) == 0:
				#it was blank, skip
				pass
			else:

				occupationNameList.append(temp)

			linesUsed += 1

		elif linesUsed == 1:
			var temp = x.split(",")
			if len(temp) == 0:
				#it was blank, skip
				pass
			else:

				occupationValuesList.append(temp)

			linesUsed = 0	#start reading a new right next iteration



	for x in range(0,len(occupationNameList)):
		var newOccupation = occupationScript.new()
		newOccupation.init(occupationNameList[x], occupationValuesList[x])
		listOfFilteredOccupations.append(newOccupation)


	Global.SetListOfOccupations(listOfFilteredOccupations)




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
