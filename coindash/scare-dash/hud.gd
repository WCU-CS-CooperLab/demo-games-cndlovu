extends CanvasLayer

signal start_game

@onready var health_bar = $MarginContainer/Health

var bar_textures = {
	"green": preload("res://assets/bar_green_200.png"),
	"yellow": preload("res://assets/bar_yellow_200.png"),
	"red": preload("res://assets/bar_red_200.png")
}

func update_score(value):
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	$MarginContainer/Time.text = str(value)
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()
	
func _on_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "You Scared!"
	$Message.show()

func update_health(value): 
	health_bar.value = value
	if value > 0.7:
		health_bar.texture_progress = bar_textures["green"]
	elif value > 0.4:
		health_bar.texture_progress = bar_textures["yellow"]
	else:
		health_bar.texture_progress = bar_textures["red"]
	
	

	
