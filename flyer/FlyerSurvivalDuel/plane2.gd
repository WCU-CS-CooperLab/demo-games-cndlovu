extends CharacterBody3D

signal dead

@export var pitch_speed = 2
@export var roll_speed = 3
@export var level_speed = 5.0
@export var forward_speed = 35
@export var fuel_burn = 1.0

signal score_changed
signal fuel_changed

var title_screen = "res://title_screen.tscn"

var max_fuel = 10.0

var fuel = 10.0:
	set = set_fuel
var score = 0:
	set = set_score

var roll_input = 0
var pitch_input = 0
var max_altitude = 30


func get_input(delta):
	pitch_input = Input.get_axis("pitch_down_2", "pitch_up_2")
	roll_input = Input.get_axis("roll_left_2", "roll_right_2")
	
	if position.y >= max_altitude and pitch_input > 0:
		position.y = max_altitude
		pitch_input = 0

func _physics_process(delta):
	get_input(delta)
	
	# Allow full-circle rotation by removing clamping on the X-axis
	rotation.x += pitch_input * pitch_speed * delta
	rotation.x = wrapf(rotation.x, -PI, PI)  # Wrap to prevent numerical overflow

	# Check for Shift key press to turn the plane 90 degrees on the Y-axis
	if Input.is_action_pressed("ui_shift"):  # Ensure "ui_shift" is mapped in Input Map
		rotation.z = lerp(rotation.z, deg_to_rad(90.0), delta * roll_speed)
	else:
		# Return to normal orientation when Shift is released
		rotation.z = lerp(rotation.z, 0.0, delta * roll_speed)

	$jet.rotation.z += roll_input * roll_speed * delta
	$jet.rotation.z = wrapf($jet.rotation.z, -PI, PI)

	# Movement logic with existing speed multiplier
	var speed_multiplier = 1.2  # Plane 2 moves faster
	velocity = -transform.basis.z * forward_speed * speed_multiplier
	velocity += transform.basis.x * $jet.rotation.z / deg_to_rad(45) * forward_speed / 2.0 * speed_multiplier

	move_and_slide()

	if get_slide_collision_count() > 0:
		die()
	fuel -= fuel_burn * delta

func set_fuel(value):
	fuel = min(value, max_fuel)
	fuel_changed.emit(fuel)
	if fuel <= 0:
		die()

func set_score(value):
	score = value
	score_changed.emit(score)

func die():
	if score > Global.high_score:
		Global.high_score = score
		Global.save_score()
	Global.player2_score = score 
	set_physics_process(false)
	$jet.hide()
	$AudioStreamPlayer.play()
	$Explosion.show()
	$Explosion.play("default")
	$PlaneSound.stop()
	await $Explosion.animation_finished
	$Explosion.hide()
	dead.emit()
	#get_tree().reload_current_scene()
	#get_tree(). change_scene_to_file(title_screen)
