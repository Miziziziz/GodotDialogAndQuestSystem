extends Node

# structure of conversation:
# conversation_id: {
# 	list of greetings [
# 		{
# 			id: id of dialog window to show
# 			conditions: (optional) list of conditions that must be met to choose this greeting
# 			add_global_thing_that_has_happened: (optional) if this greeting is chosen, add this to the list of global things that have happened
#		}
# 	]
# 	dict of dialog windows {
# 		id of dialog : {
# 			dialog text to show,
# 			responses player can choose [
#				{
#					text: text to show for this response option(can wrap to multiple lines,
#					switch_to: id of dialog window to switch to if this option is chosen
#					close_dialog: (optional) closes dialog window if chosen
#					add_global_thing_that_has_happened: (optional), adds this to list of global things that have happened
#					add_local_thing_that_has_happened: (optional), adds this to list of local things that have happened
#					conditions: (optional) a list of conditions that must be met to show this response option
#				}
#			]
# 	}
# }

# Conditions can be prepended with ! to mean that the condition must not be met.
# Conditions will be check against both local and global lists of things that have happened.
# The local_list_of_things_that_have_happened can be used for events local to a conversation, e.g. if you must ask
# questions in a specific order to get to a certain dialog window and exiting the conversation means starting over.

# To use this system for quests, just add things to the global_list_of_things_that_have_happened whenever something 
# interesting happens, e.g. "killed_all_rats", and use the conditions_met or is_condition_met methods to check if 
# the player should recieve a reward or have access to an area.

var global_list_of_things_that_have_happened = []
var local_list_of_things_that_have_happened = []

func add_global_thing_that_has_happened(ev):
	global_list_of_things_that_have_happened.append(ev)
	
func add_local_thing_that_has_happened(ev):
	local_list_of_things_that_have_happened.append(ev)

func clear_local_list_of_things_that_have_happened():
	local_list_of_things_that_have_happened = []

const CONVERSATIONS = {
	"john" : {
		"name": "Johnathold",
		"greetings" : [
			{"id": "freak_about_sara", "conditions":["talked_to_sara"]},
			{"id": "comment_on_weather", "conditions":["talked_to_john_about_weather"]},
			{"id": "generic_hello"}
		],
		"dialogs": {
			"generic_hello": {
				"text": "hi how are you?",
				"responses": [
					{"text": "how is the weather?", "switch_to": "asked_about_weather", "conditions": ["!talked_to_sara"], "add_global_thing_that_has_happened": "talked_to_john_about_weather"},
					{"text": "bye", "close_dialog":""}
				],
			},
			"asked_about_weather": {
				"text": "I think it's going to rain",
				"responses": [
					{"text": "yeah I better get going", "close_dialog":""}
				],
			},
			"comment_on_weather": {
				"text": "Looking stormy out",
				"responses": [
					{"text": "yeah it is I better get going", "close_dialog":""}
				],
			},
			"freak_about_sara": {
				"text": "Have you seen sara's new car?!",
				"responses": [
					{"text": "yeah it's pretty sick", "switch_to": "generic_hello"}
				],
			},
		}
	},
	"sara" : {
		"name": "Sarathony",
		"greetings" : [
			{"id": "generic_hello", "add_global_thing_that_has_happened": "talked_to_sara"}
		],
		"dialogs": {
			"generic_hello": {
				"text": "hi how are you?",
				"responses": [
					{"text": "how's your new car?", "switch_to": "asked_about_car", "add_local_thing_that_has_happened": "talked_to_sara_about_car"},
					{"text": "how's your new car's mpg?", "switch_to": "asked_about_car_mpg", "conditions":["talked_to_sara_about_car"]}, 
					{"text": "bye", "close_dialog":""}
				],
			},
			"asked_about_car": {
				"text": "It's pretty nice",
				"responses": [
					{"text": "what's the mpg?", "switch_to": "asked_about_car_mpg"}
				],
			},
			"asked_about_car_mpg": {
				"text": "60 mpg",
				"responses": [
					{"text": "ok cool", "switch_to": "generic_hello"}
				],
			}
		}
	}
}

func get_conversation(convo_id):
	return CONVERSATIONS[convo_id]

func conditions_met(list_of_conditions):
	for condition in list_of_conditions:
		if !is_condition_met(condition):
			return false
	return true

func is_condition_met(condition):
	if condition[0] == "!":
		return !is_condition_met(condition.substr(1, condition.length()))
	
	if condition in global_list_of_things_that_have_happened:
		return true
	if condition in local_list_of_things_that_have_happened:
		return true
	return false