
var sampleDir = "res://Assets/SelectionFolder/"
var selectionScript = load("res://Scripts/Selections/Selection.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init():

	var file = GetFilePathsInDirectory(sampleDir)

	var selections = ReadLinesFromFile(file[0])

	var listOfUnfilteredSelections = []
	var listOfFilteredSelections = []

	for x in selections:
		var temp = x.split(",")
		if len(temp) == 0:
			#it was blank, skip
			pass
		else:

			listOfUnfilteredSelections.append(temp)

	for x in listOfUnfilteredSelections:
		var newSelection = selectionScript.new()
		newSelection.init(x)
		listOfFilteredSelections.append(newSelection)

	Global.SetListOfSelections(listOfFilteredSelections)




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
