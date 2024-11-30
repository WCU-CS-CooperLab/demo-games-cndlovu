extends Area2D

@export var speed = 150  # Speed of the zombie
@export var attack_distance = 30  # Distance at which zombie attacks player
var player  # Reference to the player
var is_attacking = false  # Check if zombie is attacking

func _ready():
	# Locate the player node in the scene tree
	player = get_parent().get_node("Player")  # Assuming Player is in the same scene
	# Start with the appear animation
	$AnimatedSprite2D.animation = "appear"

func _on_animation_finished():
	# Handle what happens when different animations finish
	if $AnimatedSprite2D.animation == "appear":
		# After appear animation, switch to idle
		$AnimatedSprite2D.animation = "idle"
	elif $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D.animation = "die"
		die()

func _process(delta):
	if player:
		var distance_to_player = player.position.distance_to(position)
		
		# If the zombie is close enough, it attacks
		if distance_to_player <= attack_distance:
			if not is_attacking:
				is_attacking = true
				$AnimatedSprite2D.animation = "attack"
		else:
			is_attacking = false
			# Calculate the direction towards the player
			var direction = (player.position - position).normalized()
			# Update the zombie's position by moving in the direction of the player
			position += direction * speed * delta
			
			# Play the walk animation if the zombie is moving
			if direction.length() > 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = direction.x < 0  # Flip sprite based on direction
			else:
				$AnimatedSprite2D.animation = "idle"

func die():
	queue_free()
