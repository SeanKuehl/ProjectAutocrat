extends CanvasLayer

signal UserDoneWithBasicInfo(casteName, casteDesc)

var currentNames = []

func _ready():
	pass

func Clear():
	$CasteName.text = ""
	$CasteDesc.text = ""
	currentNames = Global.GetCurrentCasteNames()

func Init(casteName, casteDesc):
	$CasteName.text = casteName
	$CasteDesc.text = casteDesc

func HideMyStuff():
	$Panel.hide()
	$EnterNamePrompt.hide()
	$EnterDescPrompt.hide()
	$CasteName.hide()
	$CasteDesc.hide()
	$DoneButton.hide()
	$ErrorMessage.hide()


func ShowMyStuff():
	$Panel.show()
	$EnterNamePrompt.show()
	$EnterDescPrompt.show()
	$CasteName.show()
	$CasteDesc.show()
	$DoneButton.show()
	$ErrorMessage.show()



func _on_DoneButton_pressed():
	var candidateName = $CasteName.text
	var candidateDesc = $CasteDesc.text

	var duplicateName = false

	for x in currentNames:
		if candidateName == x:
			#reject it, it's already in use
			duplicateName = true


	if duplicateName:
		$ErrorMessage.text = "Sorry, that name's already in use"
	elif candidateName == "" or candidateName == " ":
		$ErrorMessage.text = "Sorry, that's not a valid name"
	elif candidateDesc == "" or candidateDesc == " ":
		$ErrorMessage.text = "Sorry, that's not a valid description"
	else:
		#pass data onto next step
		emit_signal("UserDoneWithBasicInfo", candidateName, candidateDesc)




