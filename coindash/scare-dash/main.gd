extends Node

@export var coin_scene : PackedScene
@export var playtime = 30
@export var powerup_scene : PackedScene
@export var zombie_scene : PackedScene
@export var potion_scene : PackedScene

var max_zombies_per_level = 1
var enemy_timer_wait_time = 5 
var level = 1
var score =  0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false
var potion_spawned = false
var player_infected = false


var max_health = 1
var current_health = max_health

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$HUD.update_health(1)
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	start_enemy_timer()
	

func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	$LevelSound.play()
	
func spawn_zombies():
	for i in range(level):
		var zombie_count = get_tree().get_nodes_in_group("zombies").size()
		if zombie_count < max_zombies_per_level:
			var z = zombie_scene.instantiate()
			add_child(z)
			z.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
			z.add_to_group("zombies")  
		else:
			break
	
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time= randf_range(5,10)
		$PowerupTimer.start()
		$HealUpTimer.wait_time= randf_range(4,8)
		$HealUpTimer.start()
	elif player_infected == true:
		$ZombieSound.play()
		take_damage(.15)
		player_infected = false
		

func _on_gamer_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func _on_enemy_timer_timeout():
	if playing:
		spawn_zombies()

func stop_enemy_timer():
	$EnemyTimer.stop()
	
func _on_player_hurt():
	game_over()
	
func _on_player_infected() -> void:
	player_infected = true
	
func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
		"pickup_potion":
			$PotionPickup.play()
			time_left += 2
			heal(0.25)
			
	
func _on_hud_start_game():
	new_game()

func start_enemy_timer():
	# Set up and start the enemy spawn timer
	$EnemyTimer.wait_time = enemy_timer_wait_time
	$EnemyTimer.start()
	
func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("zombies", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_health_changed(value):
	#$HUD.update_health(value)
	pass
	
func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))


func take_damage(amount: float):
	current_health = clamp(current_health - amount, 0, max_health)
	$HUD.update_health(current_health / max_health)

	if current_health <= 0:
		game_over()

func heal(amount: float):
	current_health = clamp(current_health + amount, 0, max_health)
	$HUD.update_health(current_health / max_health)


func _on_heal_up_timer_timeout() -> void:
	var p = potion_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))
