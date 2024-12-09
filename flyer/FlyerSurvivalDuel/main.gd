extends Node3D

var chunk = preload("res://chunk.tscn")

var num_chunks = 1
var chunk_size = 200
var max_position1 = -100
var max_position2 = -100
var player1_dead = false
var player2_dead = false

@export var player1 : NodePath
@export	var player2 : NodePath


func _process(delta):
	if $Plane.position.z < max_position1:
		num_chunks += 1
		var new_chunk = chunk.instantiate()
		new_chunk.position.z = max_position1 - chunk_size / 2
		new_chunk.level = num_chunks / 4
		add_child(new_chunk)
		max_position1 -= chunk_size
	if $Plane2.position.z < max_position2:
		num_chunks += 1
		var new_chunk = chunk.instantiate()
		new_chunk.position.z = max_position2 - chunk_size / 2
		new_chunk.level = num_chunks / 4
		add_child(new_chunk)
		max_position2 -= chunk_size


func _on_plane_dead() -> void:
	player1_dead = true
	check_game_over()

func _on_plane_2_dead() -> void:
	player2_dead = true
	check_game_over()

func check_game_over():
	if player1_dead and player2_dead:
		# Determine the winner
		if Global.player1_score > Global.player2_score:
			Global.winner = "Player 1"
		elif Global.player2_score > Global.player1_score:
			Global.winner = "Player 2"
		else:
			Global.winner = "It's a Tie!"

		# Transition to the title screen
		get_tree().change_scene_to_file("res://title_screen.tscn")
