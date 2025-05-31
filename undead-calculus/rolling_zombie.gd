#Sprite credit: https://ironnbutterfly.itch.io/zombie-sprite
extends CharacterBody2D
var rng = RandomNumberGenerator.new()
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var SPEED = rng.randf_range(200.0, 500.0)
@onready var anim = get_node("AnimationPlayer")
const ROLLINGZOMBIE = preload("res://RollingZombie.tscn")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	get_node("AnimatedSprite2D").flip_h = true
	anim.play("Rolling")
	velocity.x = -1 * SPEED
	move_and_slide()

func spawn_roll_zombie():
	var zombie_roll_node = ROLLINGZOMBIE.instantiate()
	zombie_roll_node.position = Vector2(1224.0,300)
	get_parent().add_child(zombie_roll_node)


func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.onHit(10)
		get_parent().roll_spawned = false
		queue_free()

func delete_zombie():
	queue_free()
