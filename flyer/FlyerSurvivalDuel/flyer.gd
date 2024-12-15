extends Node

# Declare an empty dictionary for players
var players = {}

func _ready():
	# Initialize the player dictionaries dynamically
	players["1"] = {
		"viewport": $HBoxContainer/SubViewportContainer/SubViewport,
		"camera": $HBoxContainer/SubViewportContainer/SubViewport/Camera3D,
		"player": $Main/Plane
	}
	players["2"] = {
		"viewport": $HBoxContainer/SubViewportContainer2/SubViewport,
		"camera": $HBoxContainer/SubViewportContainer2/SubViewport/Camera3D,
		"player": $Main/Plane2
	}
	
	# Example usage: Assign one viewport's world to another
	players["2"]["viewport"].world_3d = players["1"]["viewport"].world_3d
