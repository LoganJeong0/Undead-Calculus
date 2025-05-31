#attribute for characterBoyd2d tutorial/creation: youtube - freeCodeCamp.org
#Attribute for template code: Built into Godot characterBody2d
#Player sprite credit: https://chasersgaming.itch.io/adventure-asset-character-agent-nes
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var Health = 100
var inAnim = false
var stopMove = false
var playerDead = false
var rockHit = false

@onready var anim = get_node("AnimationPlayer")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if (!stopMove):
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY - 150
			anim.play("Jump")
		
	if velocity.y == 0 and inAnim == false:
			anim.play("Idle")
			
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
			anim.play("Crouch")
			inAnim = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Crouch" || anim_name == "Hurt":
		inAnim = false
	if anim_name == "Death":
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://lose_screen.tscn")


	
func onHit(num):
	Health -= num
	if (Health > 0):
		anim.play("Hurt")
		inAnim = true
	if (Health <= 0):
		anim.play("Death")
		playerDead = true
		inAnim = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == ("Rock"):
		rockHit = true
		
func reset_rockHit():
	rockHit = false
