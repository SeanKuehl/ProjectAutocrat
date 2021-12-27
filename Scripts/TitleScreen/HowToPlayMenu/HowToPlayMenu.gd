extends Control

var sampleDir = "user://HowToPlay/"
var adviceList = []
var adviceIndex = 0
var adviceIndexMin = 0
var adviceIndexMax = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	init()


func init():
	#Init(passedName)
	var file = GetFilePathsInDirectory(sampleDir)

	var advice = ReadLinesFromFile(file[0])




	for x in advice:



		var temp = x
		if len(temp) == 0:
			#it was blank, skip
			pass
		else:

			adviceList.append(temp)


	adviceIndexMax = len(adviceList)-1

	UpdateAdvice()


func UpdateAdvice():
	$AdviceLabel.text = adviceList[adviceIndex]







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


func _on_NextButton_pressed():
	if adviceIndex == adviceIndexMax:
		#don't go out of array bounds
		pass
	else:
		adviceIndex += 1

	UpdateAdvice()


func _on_LastButton_pressed():
	if adviceIndex == adviceIndexMin:
		#don't go below array bounds
		pass
	else:
		adviceIndex -= 1

	UpdateAdvice()


func _on_DoneButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
