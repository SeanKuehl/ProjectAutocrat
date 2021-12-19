extends Node2D

onready var selectionLoaderScript = load("res://Scripts/Selections/SelectionLoader.gd")
onready var selectionMenu = load("res://Scenes/Selections/SelectionMenu.tscn")

onready var rightLoaderScript = load("res://Scripts/Rights/RightsLoader.gd")
onready var rightMenu = load("res://Scenes/Rights/RightMenu.tscn")

onready var occupationLoaderScript = load("res://Scripts/Occupations/OccupationsLoader.gd")
onready var occupationMenu = load("res://Scenes/Occupations/OccupationMenu.tscn")

onready var basicInfoMenu = load("res://Scenes/Castes/CasteBasicInfoMenu.tscn")

onready var mainMenu = load("res://Scenes/MainMenu/MainMenu.tscn")

onready var thisNode = get_tree().get_current_scene()

signal EditCasteNameAndDesc(casteName, casteDesc, casteID)
signal EditCasteSelections(selections, casteID)

#var game = preload("res://Scenes/SelectionMenu.tscn").instance()
var currentSelectionList = 0
var currentRightList = 0
var currentOccupationList = 0
var casteName = ""
var casteDescription = ""

var currentCasteInfoList = []
var currentCasteID = -1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentSelectionIndex = 0
var creatingCaste = false
var editingCaste = false




# Called when the node enters the scene tree for the first time.
func _ready():
	selectionLoaderScript = selectionLoaderScript.new()
	selectionLoaderScript.init()

	rightLoaderScript = rightLoaderScript.new()
	rightLoaderScript.init()

	occupationLoaderScript = occupationLoaderScript.new()
	occupationLoaderScript.init()




	basicInfoMenu = basicInfoMenu.instance()
	add_child(basicInfoMenu)
	get_node("CasteBasicInfoMenu").connect("UserDoneWithBasicInfo", self, "DoneWithBasicInfo")
	#emit_signal("UserDoneWithBasicInfo", candidateName, candidateDesc)
	get_node("CasteBasicInfoMenu").HideMyStuff()

	selectionMenu = selectionMenu.instance()
	add_child(selectionMenu)
	get_node("SelectionMenu").connect("UserDoneWithSelectionChanges", self,  "GetUpdatesSelectionListFromMenu")
	get_node("SelectionMenu").HideMyStuff()


	rightMenu = rightMenu.instance()
	add_child(rightMenu)
	get_node("RightMenu").connect("UserDoneWithRightChanges", self,  "GetUpdatesRightListFromMenu")
	get_node("RightMenu").HideMyStuff()

	occupationMenu = occupationMenu.instance()
	add_child(occupationMenu)
	get_node("OccupationMenu").connect("UserDoneWithOccupationChanges", self,  "GetUpdatesOccupationListFromMenu")
	get_node("OccupationMenu").HideMyStuff()

	#this works
	#selectionMenu = selectionMenu.instance()
	#add_child(selectionMenu)
	#get_node("SelectionMenu").connect("UserDoneWithSelectionChanges", self,  "GetUpdatesSelectionListFromMenu")
	#get_node("SelectionMenu").CreateSelectionList()

	#this works
	#rightMenu = rightMenu.instance()
	#add_child(rightMenu)
	#get_node("RightMenu").connect("UserDoneWithRightChanges", self,  "GetUpdatesRightListFromMenu")
	#get_node("RightMenu").CreateRightList()

	#this works!
	#occupationMenu = occupationMenu.instance()
	#add_child(occupationMenu)
	#get_node("OccupationMenu").connect("UserDoneWithOccupationChanges", self,  "GetUpdatesOccupationListFromMenu")
	#get_node("OccupationMenu").CreateOccupationList()

	#var selectionList = Global.GetListOfSelections()
	#var selectionName = selectionList[currentSelectionIndex].GetName()
	#var selectionValues = selectionList[currentSelectionIndex].GetValues()

	mainMenu = mainMenu.instance()
	mainMenu.Init(0,0,0)
	mainMenu.ConnectSignalsFromRoot(thisNode)
	mainMenu.connect("UserWantsToCreateCaste", self, "CreateCaste")
	add_child(mainMenu)


	#emit_signal("UserDoneWithBasicInfo", candidateName, candidateDesc)

	#$Label.text = selectionName
	#$Label2.text = str((currentSelectionIndex+1)) + "/"+str(len(selectionList))

	#for x in selectionValues:
	#	$ItemList.add_item(x)




func GetUpdatesSelectionListFromMenu(selectionList):

	currentSelectionList = selectionList





	if editingCaste:
		FinishEditOfSelections()

	if creatingCaste:
		get_node("SelectionMenu").HideMyStuff()

		get_node("RightMenu").ShowMyStuff()
		get_node("RightMenu").CreateRightList()


func GetUpdatesRightListFromMenu(rightList):
	currentRightList = rightList

	if creatingCaste:
		get_node("RightMenu").HideMyStuff()

		get_node("OccupationMenu").ShowMyStuff()
		get_node("OccupationMenu").CreateOccupationList()


func GetUpdatesOccupationListFromMenu(occupationList):

	currentOccupationList = occupationList

	if creatingCaste:
		get_node("OccupationMenu").HideMyStuff()

		FinishCreateCaste()


func CreateCaste():
	get_node("MainMenu").HideMyStuff()
	creatingCaste = true
	editingCaste = false

	get_node("CasteBasicInfoMenu").Clear()
	get_node("CasteBasicInfoMenu").ShowMyStuff()


func FinishCreateCaste():

	var listToPass = [casteName, casteDescription, currentSelectionList, currentRightList, currentOccupationList]
	get_node("MainMenu").ShowMyStuff()
	get_node("MainMenu").AddNewlyCreatedCaste(listToPass)

func DoneWithBasicInfo(passedName, passedDesc):
	casteName = passedName
	casteDescription = passedDesc

	if editingCaste:
		FinishEditOfNameAndDesc()

	if creatingCaste:
		get_node("CasteBasicInfoMenu").HideMyStuff()

		get_node("SelectionMenu").ShowMyStuff()
		get_node("SelectionMenu").CreateSelectionList()


func ConnectCasteEditMenuSignals(editMenuObject):
	#"UserWantsToEditNameAndDescription"
	editMenuObject.connect("UserWantsToEditNameAndDescription", self, "StartEditOfNameAndDesc")
	editMenuObject.connect("UserWantsToEditSelections", self, "StartEditOfSelections")


func StartEditOfSelections(selections, casteID):
	get_node("MainMenu").HideMyStuff()
	currentCasteID = casteID

	editingCaste = true
	get_node("SelectionMenu").ShowMyStuff()
	get_node("SelectionMenu").EditSelectionList(selections)


func FinishEditOfSelections():
	#currentSelectionList

	editingCaste = false
	get_node("SelectionMenu").HideMyStuff()

	emit_signal("EditCasteSelections", currentSelectionList, currentCasteID)
	#send the new name, desc and id back to main menu so it can edit the right caste
	get_node("MainMenu").ShowMyStuff()

func StartEditOfNameAndDesc(passedName, passedDesc, casteID):

	get_node("MainMenu").HideMyStuff()
	currentCasteID = casteID

	editingCaste = true
	get_node("CasteBasicInfoMenu").ShowMyStuff()
	get_node("CasteBasicInfoMenu").Init(passedName, passedDesc)	#pass the name and description

func FinishEditOfNameAndDesc():
	editingCaste = false
	get_node("CasteBasicInfoMenu").HideMyStuff()

	emit_signal("EditCasteNameAndDesc", casteName, casteDescription, currentCasteID)
	#send the new name, desc and id back to main menu so it can edit the right caste
	get_node("MainMenu").ShowMyStuff()

func _physics_process(_delta):
	#print($ItemList.get_selected_items())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
