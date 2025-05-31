#Background credit: https://www.reddit.com/r/IndieGaming/comments/aguzdo/pixel_art_parallax_effect_for_my_postapocalyptic/
#Broken heart sprite credit: https://www.shutterstock.com/search/broken-heart-pixel
extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_level.tscn")
