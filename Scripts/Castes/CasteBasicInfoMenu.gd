extends CanvasLayer

signal UserDoneWithBasicInfo(casteName, casteDesc)

func _ready():
	pass

func Clear():
	$CasteName.text = ""
	$CasteDesc.text = ""

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

	#also check for duplicate names in future!

	if candidateName == "" or candidateName == " ":
		$ErrorMessage.text = "Sorry, that's not a valid name"
	elif candidateDesc == "" or candidateDesc == " ":
		$ErrorMessage.text = "Sorry, that's not a valid description"
	else:
		#pass data onto next step
		emit_signal("UserDoneWithBasicInfo", candidateName, candidateDesc)




