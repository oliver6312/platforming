extends Control

@export_file("*.json") var dialogue_file

var dialogue = []
var current_dialogue_id = 0
var dialogue_active = false

func _ready() -> void:
	$NinePatchRect.visible = false
	$NinePatchRect2.visible = false

func start():
	if dialogue_active:
		return
	$NinePatchRect.visible = true
	dialogue_active = true
	dialogue = load_dialogue()
	print(dialogue)
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	var file = FileAccess.open("res://Scripts/UI/Dialogue/dad_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event: InputEvent) -> void:
	if !dialogue_active:
		return
	if event.is_action_pressed("attack"):
		next_script()

func next_script():
	current_dialogue_id += 1
	print(current_dialogue_id)
#	print(len(dialogue))
	if current_dialogue_id >= len(dialogue):
		$NinePatchRect.visible = false
		dialogue_active = false
		var dialogue_over = true
		return
	
	if current_dialogue_id == 3:
		$NinePatchRect2.visible = true
#		dialogue_active = false
#		var dialogue_over = true
#		return
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
	
