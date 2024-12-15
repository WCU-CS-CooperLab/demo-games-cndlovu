extends Control


func _on_texture_button_pressed() -> void:
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://flyer.tscn")

func _ready():
	$AudioStreamPlayer.play()
	$WinnerLabel.text = "Winner: " + Global.winner
	$HighScoreLabel.text = "High Score: " + str(Global.high_score)
	#$Label2.text = "High Score: " + str(Global.high_score)
