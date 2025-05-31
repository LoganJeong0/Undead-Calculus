#Zombie Sprite credit: https://ironnbutterfly.itch.io/zombie-sprite
extends CharacterBody2D
var rng = RandomNumberGenerator.new()

@onready var anim = get_node("AnimationPlayer")
var rock_node
var dead = false
var inAnim = false

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

const ZOMBIE = preload("res://Zombie.tscn")
const ROCK = preload("res://Rock.tscn")

var SPEED = rng.randf_range(100.0, 200.0)
var holdSpeed = SPEED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	get_node("AnimatedSprite2D").flip_h = true
	if inAnim:
		velocity.x = 0
	if (!dead && !inAnim):
		velocity.x = -1 * SPEED
		anim.play("Walk")
	move_and_slide() 


func kill_zombie():
	if not dead:
		velocity.x = 0
		dead = true
		anim.play("Death")


func spawn_zombie():
	var zombie_node = ZOMBIE.instantiate()
	zombie_node.position = Vector2(1224.0, 320.0)
	get_parent().add_child(zombie_node)
	zombie_node.name = "Zombie"
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		queue_free()
	if anim_name == "Throw":
		inAnim = false

func spawn_rock():
	anim.play("Throw")
	inAnim = true
	rock_node = ROCK.instantiate()
	rock_node.add_to_group("Rock")
	rock_node.global_position = global_position
	rock_node.global_position.y += -50
	get_parent().add_child(rock_node)
