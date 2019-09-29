extends Control

onready var people_to_talk_to = $PeopleToTalkTo
onready var dialog_window = $DialogWindow

func _ready():
	for button in people_to_talk_to.get_children():
		button.connect("button_up", self, "start_conversation", [button.text])
	dialog_window.connect("closed", self, "end_conversation")
	end_conversation()
	dialog_window.hide()

func end_conversation():
	people_to_talk_to.show()

func start_conversation(convo_id):
	people_to_talk_to.hide()
	dialog_window.load_conversation(convo_id)
