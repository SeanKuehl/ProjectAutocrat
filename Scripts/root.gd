extends Node2D

onready var selectionLoaderScript = load("res://Scripts/Selections/SelectionLoader.gd")
onready var selectionMenu = load("res://Scenes/Selections/SelectionMenu.tscn")

onready var rightLoaderScript = load("res://Scripts/Rights/RightsLoader.gd")
onready var rightMenu = load("res://Scenes/Rights/RightMenu.tscn")

onready var occupationLoaderScript = load("res://Scripts/Occupations/OccupationsLoader.gd")
onready var occupationMenu = load("res://Scenes/Occupations/OccupationMenu.tscn")

#var game = preload("res://Scenes/SelectionMenu.tscn").instance()
var currentSelectionList = 0
var currentRightList = 0
var currentOccupationList = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentSelectionIndex = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	selectionLoaderScript = selectionLoaderScript.new()
	selectionLoaderScript.init()

	rightLoaderScript = rightLoaderScript.new()
	rightLoaderScript.init()

	occupationLoaderScript = occupationLoaderScript.new()
	occupationLoaderScript.init()

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

	#$Label.text = selectionName
	#$Label2.text = str((currentSelectionIndex+1)) + "/"+str(len(selectionList))

	#for x in selectionValues:
	#	$ItemList.add_item(x)


func GetUpdatesSelectionListFromMenu(selectionList):
	currentSelectionList = selectionList



func GetUpdatesRightListFromMenu(rightList):
	currentRightList = rightList


func GetUpdatesOccupationListFromMenu(occupationList):

	currentOccupationList = occupationList



func _physics_process(_delta):
	#print($ItemList.get_selected_items())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
