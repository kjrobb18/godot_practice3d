extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State = (func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)
	).call()

func _ready() -> void:
	pass
	# Give every state a reference to the state machine.
	#for state_node: State in find_children("*", "State"):
		#state_node.finished.connect(_transition_to_next_state)

	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	#state.enter("")
	
func transition_state(next_state: State):
	match next_state: 
		pass
		
