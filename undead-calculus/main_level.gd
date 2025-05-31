#attribute for tutorial on buttons, node connections, syntax: youtube - freeCodeCamp.org
#Background credit: https://www.reddit.com/r/IndieGaming/comments/aguzdo/pixel_art_parallax_effect_for_my_postapocalyptic/
#Heart Sprite Credit: https://opengameart.org/content/heart-pixel-art

extends Node2D
var rng = RandomNumberGenerator.new()

const ZOMBIE = preload("res://Zombie.tscn")
const ROCK = preload("res://Rock.tscn")
const ROLLINGZOMBIE = preload("res://RollingZombie.tscn")
#@export var ZombieScene: PackedScene
#@export var RollingZombieScene: PackedScene
@onready var player = $Player

var randNum
var fakeout = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var numQuestions = -1
var numCorrect = 0
var accuracy = 100
var Score = 0
var currentlyDying = false #True if zombie is dying, used to make sure zombie can't attempt to throw rock while dying from correct question
var ready_spawn = false #True if zombie node is within collision shape "RollerSpawnZone", used as condition to spawn roller zombies 
var zombie_spawned = true #True if a zombie node is in Main level, used to avoid calling kill_zombie when theres no zombie node instantiated
var roll_spawned = false #True if a rolling zombie node is instantiated, used to ensure only 1 can be in the level at a time
var activeThrow = false #True if zombie is throwing a rock, or when a rock is flying, used to make sure only one rock can be on screen at any time
#var zombieDead = false #True is zombie is dead

var gen_question = true
var b1_correct = false
var b2_correct = false
var b3_correct = false
var b4_correct = false

@onready var zombie_node = $Zombie

func _process(_delta: float) -> void:
	print(numCorrect)
	if numQuestions == 0:
		accuracy = 100
	else:
		accuracy = int((float(numCorrect) / numQuestions) * 100)
	
	if accuracy > 100:
		accuracy = 100
	$CanvasLayer/HP.text = str(player.Health) + "%"
	$CanvasLayer/Score.text = "SCORE: " + str(Score)
	$CanvasLayer/Accuracy.text = "ACCURACY: " + str(accuracy) + "%"
	random_spawn_hostile()
	if player.rockHit:
		activeThrow = false
		player.reset_rockHit()
	if gen_question:
		generate_questions()
		#gen_question = false


#ZOMBIE CODE
func spawn_zombie():
	zombie_node = ZOMBIE.instantiate()
	zombie_node.position = Vector2(1224.0, 281.0)
	get_parent().add_child(zombie_node)
	zombie_node.name = "Zombie"
	

func _on_kill_move_zone_body_exited(body: Node2D) -> void:
		if body.is_in_group("Zombie"):
			body.kill_zombie()
			zombie_spawned = false
			player.onHit(30)
			await get_tree().create_timer(3).timeout  #Await attribution: https://forum.godotengine.org/t/how-to-use-await-in-godot-4-0/6109
			spawn_zombie()
			zombie_spawned = true





#SPAWN CODE
func random_spawn_hostile():
	if ready_spawn: 
		if !roll_spawned:
			randNum = int(rng.randf_range(1.0, 300.0))
			if  randNum == 2:
				roll_spawned = true
				var zombie_roll_node = ROLLINGZOMBIE.instantiate()
				zombie_roll_node.position = Vector2(1224.0, 300.0)
				add_child(zombie_roll_node)
		
		if !activeThrow:
			randNum = int(rng.randf_range(1.0,200.0))
			if  randNum == 2 && !currentlyDying:
				activeThrow = true
				zombie_node.spawn_rock()




#ROLLER CODE
func _on_roller_spawn_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Zombie"):
		ready_spawn = true
		

func _on_roller_spawn_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Zombie"):
		ready_spawn = false
			
func _on_del_zombie_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rolling_Zombie"):
		Score += 50
		roll_spawned = false
		body.delete_zombie()

		
	
	
	
#ROCK CODE
func _on_rock_del_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rock"):
		Score += 50
		zombie_node.rock_node.queue_free()
		activeThrow = false




#BUTTON CODE
func generate_questions():
	numQuestions += 1
	var buttons = [
	$CanvasLayer/Button1,
	$CanvasLayer/Button2,
	$CanvasLayer/Button3,
	$CanvasLayer/Button4
]
	var correct_buttons = [false, false, false, false]
	var num1 = (int(rng.randf_range(1.0, 10.0)))
	var num2 = (int(rng.randf_range(1.0, 10.0)))
	var product = num1 * num2
	var exponent = num2 - 1
	for i in range (9):
		var generate = int(rng.randf_range(1, 4))
		var generate2 = int(rng.randf_range(1,2))
		if generate == 1:
			if generate2 == 1:
				fakeout[i] = product + int(rng.randf_range(1, 3))
			else:
				fakeout[i] = exponent + int(rng.randf_range(1, 3))
		
		if generate == 2:
			if generate2 == 1:
				fakeout[i] = product - int(rng.randf_range(1, 3))
			else:
				fakeout[i] = exponent - int(rng.randf_range(1, 3))
		
		if generate == 3:
			if generate2 == 1:
				fakeout[i] = product * int(rng.randf_range(1, 3))
			else:
				fakeout[i] = exponent * rng.int(rng.randf_range(1, 3))
		
		if generate == 4:
			if generate2 == 1:
				fakeout[i] = product / int(rng.randf_range(1, 3))
			else:
				fakeout[i] = exponent / int(rng.randf_range(1, 3))
	
	var correctA = (int(rng.randf_range(1.0, 4.0)))
	$CanvasLayer/Question.text ="d/dx (" + str(num1) + "x^" + str(num2) + ") = ?"
	if correctA == 1:
		b1_correct = true
	elif correctA == 2:
		b2_correct = true
	elif correctA == 3:
		b3_correct = true
	else:
		b4_correct = true
	
	correct_buttons[correctA - 1] = true
	
	for i in range(4):
		if i == correctA - 1:
			buttons[i].text = str(product) + "x^" + str(exponent)
			
		else:
			buttons[i].text = str(fakeout[rng.randf_range(0,9)]) + "x^" + str(fakeout[rng.randf_range(0,9)])

func _on_button_1_pressed() -> void:
	if b1_correct && zombie_spawned:
		numCorrect += 1
		Score += 100
		currentlyDying = true
		print("Correct!")
		#zombie_node.velocity.x = 0
		zombie_spawned = false
		zombie_node.kill_zombie()
		gen_question = false
		resetButton()
		await get_tree().create_timer(3).timeout
		spawn_zombie()
		zombie_spawned = true
		currentlyDying = false
	else:
		print("Wrong")
		gen_question = false
		resetButton()

func _on_button_2_pressed() -> void:
	if b2_correct && zombie_spawned:
		numCorrect += 1
		Score += 100
		currentlyDying = true
		print("Correct!")
		#zombie_node.velocity.x = 0
		zombie_spawned = false
		zombie_node.kill_zombie()
		gen_question = false
		resetButton()
		await get_tree().create_timer(3).timeout
		spawn_zombie()
		zombie_spawned = true
		currentlyDying = false
	else:
		print("Wrong")
		gen_question = false
		resetButton()
		
func _on_button_3_pressed() -> void:
	if b3_correct && zombie_spawned:
		numCorrect += 1
		Score += 100
		currentlyDying = true
		print("Correct!")
		#zombie_node.velocity.x = 0
		zombie_spawned = false
		zombie_node.kill_zombie()
		gen_question = false
		resetButton()
		await get_tree().create_timer(3).timeout
		spawn_zombie()
		zombie_spawned = true
		currentlyDying = false
	else:
		print("Wrong")
		gen_question = false
		resetButton()


func _on_button_4_pressed() -> void:
	if b4_correct && zombie_spawned:
		numCorrect += 1
		Score += 100
		currentlyDying = true
		print("Correct!")
		#zombie_node.velocity.x = 0
		zombie_spawned = false
		zombie_node.kill_zombie()
		gen_question = false
		resetButton()
		await get_tree().create_timer(3).timeout
		spawn_zombie()
		zombie_spawned = true
		currentlyDying = false
	else:
		print("Wrong")
		gen_question = false
		resetButton()
	
func resetButton():
	b1_correct = false
	b2_correct = false
	b3_correct = false
	b4_correct = false
	gen_question = true
