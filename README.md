```
To write conversations, go to DialogAndQuestManager.gd and alter the CONVERSATIONS const
To start a conversation, call load_conversation on the DialogWindow scene

structure of conversation:
conversation_id: {
	list of greetings [
		{
			id: id of dialog window to show
			conditions: (optional) list of conditions that must be met to choose this greeting
			add_global_thing_that_has_happened: (optional) if this greeting is chosen, add this to the list of global things that have happened
	}
	]
	dict of dialog windows {
		id of dialog : {
			dialog text to show,
			responses player can choose [
			{
				text: text to show for this response option(can wrap to multiple lines,
				switch_to: id of dialog window to switch to if this option is chosen
				close_dialog: (optional) closes dialog window if chosen
				add_global_thing_that_has_happened: (optional), adds this to list of global things that have happened
				add_local_thing_that_has_happened: (optional), adds this to list of local things that have happened
				conditions: (optional) a list of conditions that must be met to show this response option
			}
		]
	}
}

Conditions can be prepended with ! to mean that the condition must not be met.
Conditions will be check against both local and global lists of things that have happened.
The local_list_of_things_that_have_happened can be used for events local to a conversation, e.g. if you must ask
questions in a specific order to get to a certain dialog window and exiting the conversation means starting over.

To use this system for quests, just add things to the global_list_of_things_that_have_happened whenever something 
interesting happens, e.g. "killed_all_rats", and use the conditions_met or is_condition_met methods to check if 
the player should recieve a reward or have access to an area.
```
