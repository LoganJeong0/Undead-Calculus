extends CharacterBody2D


var speed = 500
var spin_speed = 250

func _ready() -> void:
	var actual_distance = (global_position.x - 77) / 925
	velocity.x = (-speed)
	#velocity.x = -speed
	#velocity.x = -10
	velocity.y = actual_distance * -420
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation_degrees += spin_speed * delta
	velocity.y += delta * 440.0
	move_and_slide()
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.onHit(10)
		queue_free()
	
