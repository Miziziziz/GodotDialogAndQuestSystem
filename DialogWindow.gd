extends Control

var dialog_response = preload("res://DialogResponse.tscn")

onready var name_display = $TextDisplay/NameDisplay
onready var text_display = $TextDisplay/TextEdit
onready var response_container = $ResponseOptions/ScrollContainer/VBoxContainer
var cur_convo = ""

signal closed

func _ready():
	load_conversation("john")

func load_conversation(convo_id):
	show()
	DialogAndQuestManager.clear_local_list_of_things_that_have_happened()
	cur_convo = DialogAndQuestManager.get_conversation(convo_id)
	name_display.text = cur_convo.name
	var greeting_id = ""
	for greeting in cur_convo.greetings:
		if not "conditions" in greeting or DialogAndQuestManager.conditions_met(greeting.conditions):
			greeting_id = greeting.id
			if "add_global_thing_that_has_happened" in greeting:
				DialogAndQuestManager.add_global_thing_that_has_happened(greeting.add_global_thing_that_has_happened)
			break
	load_dialog_window(greeting_id)

func load_dialog_window(dialog_id):
	clear_response_options()
	var dialog = cur_convo.dialogs[dialog_id]
	text_display.text = dialog.text
	for response in dialog.responses:
		if not "conditions" in response or DialogAndQuestManager.conditions_met(response.conditions):
			add_response_option(response)

func close_dialog_display():
	hide()
	emit_signal("closed")

func add_response_option(response_info):
	var new_dialog_response = dialog_response.instance()
	new_dialog_response.text = response_info.text
	response_container.add_child(new_dialog_response)
	var dialog_response_button = new_dialog_response.get_node("Button")
	
	if "add_global_thing_that_has_happened" in response_info:
		dialog_response_button.connect("button_up", DialogAndQuestManager, "add_global_thing_that_has_happened", [response_info.add_global_thing_that_has_happened])
	if "add_local_thing_that_has_happened" in response_info:
		dialog_response_button.connect("button_up", DialogAndQuestManager, "add_local_thing_that_has_happened", [response_info.add_local_thing_that_has_happened])
	
	if "close_dialog" in response_info:
		dialog_response_button.connect("button_up", self, "close_dialog_display")
	else:
		dialog_response_button.connect("button_up", self, "load_dialog_window", [response_info.switch_to])

func clear_response_options():
	for child in response_container.get_children():
		child.queue_free()
